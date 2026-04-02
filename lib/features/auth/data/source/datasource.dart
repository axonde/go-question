import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../models/user_model.dart';

abstract class IAuthRemoteDataSource {
  // Получить текущую модель
  UserModel? getCurrentUser();

  // Состояние аутентификации
  Stream<String?> get authStateChanges;

  // Вход по почте/паролю
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  // Регистрация
  Future<UserModel?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  // Вход по номеру телефона
  Future<void> signInWithPhoneNumber({
    required String phoneNumber,
    required Function(String code) onCodeSent,
    required Function(String error) onError,
  });

  // Выход
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  final firebase.FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl(this._firebaseAuth);

  @override
  UserModel? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  @override
  Stream<String?> get authStateChanges =>
      _firebaseAuth.authStateChanges().map((user) => user?.uid);

  @override
  Future<void> signInWithPhoneNumber({
    required String phoneNumber,
    required Function(String code) onCodeSent,
    required Function(String error) onError,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        onError(e.message ?? 'Ошибка верификации');
      },
      codeSent: (verificationId, resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user != null ? UserModel.fromFirebaseUser(result.user!) : null;
  }

  @override
  Future<UserModel?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (result.user != null) {
      await result.user!.updateDisplayName(name);
      await result.user!.reload();
      final updatedUser = _firebaseAuth.currentUser;
      return updatedUser != null ? UserModel.fromFirebaseUser(updatedUser) : null;
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}