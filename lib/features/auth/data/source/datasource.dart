import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/utils/auth_remote_exception_mapper.dart';
import '../../domain/entities/registration_input_entity.dart';
import '../models/registration_input_model.dart';

abstract class IAuthRemoteDataSource {
  RegistrationInput? getCurrentUser();
  bool isCurrentUserEmailVerified();
  Stream<String?> get authStateChanges;

  Future<RegistrationInput?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String nickname,
  });

  Future<RegistrationInput?> signInWithGoogle();

  Future<void> sendEmailVerification();

  Future<bool> checkEmailVerified();

  Future<void> deleteCurrentUser();

  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  final firebase.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._googleSignIn);

  @override
  RegistrationInput? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    return user?.toRegistrationInput();
  }

  @override
  bool isCurrentUserEmailVerified() {
    return _firebaseAuth.currentUser?.emailVerified ?? false;
  }

  @override
  Stream<String?> get authStateChanges =>
      _firebaseAuth.authStateChanges().map((u) => u?.uid);

  @override
  Future<RegistrationInput?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user?.toRegistrationInput();
    } catch (error) {
      throw mapAuthRemoteException(error);
    }
  }

  @override
  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String nickname,
  }) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        await result.user!.updateDisplayName(nickname);
        await result.user!.sendEmailVerification();
      }
      return email;
    } catch (error) {
      throw mapAuthRemoteException(error);
    }
  }

  @override
  Future<RegistrationInput?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = firebase.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result = await _firebaseAuth.signInWithCredential(credential);
      return result.user?.toRegistrationInput();
    } catch (error) {
      throw mapAuthRemoteException(error);
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException();
    }

    try {
      await user.sendEmailVerification();
    } catch (error) {
      throw mapAuthRemoteException(error);
    }
  }

  @override
  Future<bool> checkEmailVerified() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException();
    }

    try {
      await user.reload();
    } on firebase.FirebaseAuthException catch (error) {
      // In some sessions Firebase can return transient 403/auth errors on reload.
      // Force token refresh and retry once before failing.
      if (_shouldRetryReloadAfterTokenRefresh(error)) {
        final refreshedUser = _firebaseAuth.currentUser;
        if (refreshedUser == null) {
          throw const AuthException();
        }
        await refreshedUser.getIdToken(true);
        await refreshedUser.reload();
      } else {
        throw mapAuthRemoteException(error);
      }
    } catch (error) {
      throw mapAuthRemoteException(error);
    }

    // Read the actual current user after reload, not the stale local reference.
    return _firebaseAuth.currentUser?.emailVerified ?? false;
  }

  bool _shouldRetryReloadAfterTokenRefresh(
    firebase.FirebaseAuthException error,
  ) {
    final code = error.code;
    final lowerMessage = (error.message ?? '').toLowerCase();

    return code == 'user-token-expired' ||
        code == 'invalid-user-token' ||
        (code == 'internal-error' && lowerMessage.contains('403'));
  }

  @override
  Future<void> deleteCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException();
    }

    try {
      await user.delete();
    } catch (error) {
      throw mapAuthRemoteException(error);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } catch (error) {
      throw mapAuthRemoteException(error);
    }
  }
}
