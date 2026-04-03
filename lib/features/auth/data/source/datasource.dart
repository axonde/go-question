import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import '../../../user/data/models/user_model.dart';

abstract class IAuthRemoteDataSource {
  UserModel? getCurrentUser();
  bool isCurrentUserEmailVerified();
  Stream<String?> get authStateChanges;

  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<UserModel?> signInWithGoogle();

  /// Отправляет письмо верификации текущему пользователю
  Future<void> sendEmailVerification();

  /// Перезагружает профиль и возвращает актуальный статус верификации
  Future<bool> checkEmailVerified();

  /// Удаляет незаверифицированный аккаунт (для кнопки «Изменить почту»)
  Future<void> deleteCurrentUser();

  /// Сохраняет / обновляет документ пользователя в Firestore
  Future<void> saveUserToFirestore();

  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  final firebase.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(
    this._firebaseAuth,
    this._googleSignIn,
    this._firestore,
  );

  // ──────────────────────────────────────────────
  // Sync helpers
  // ──────────────────────────────────────────────

  @override
  UserModel? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  @override
  bool isCurrentUserEmailVerified() {
    return _firebaseAuth.currentUser?.emailVerified ?? false;
  }

  @override
  Stream<String?> get authStateChanges =>
      _firebaseAuth.authStateChanges().map((u) => u?.uid);

  // ──────────────────────────────────────────────
  // Email / password
  // ──────────────────────────────────────────────

  @override
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (result.user != null) {
      // Пытаемся получить профиль из Firestore
      final userDoc = await _firestore.collection('users').doc(result.user!.uid).get();
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      }
      return UserModel.fromFirebaseUser(result.user!);
    }
    return null;
  }

  /// Регистрация: создаёт аккаунт, устанавливает displayName, отправляет
  /// письмо верификации. Возвращает email (не UserModel — пользователь ещё не
  /// верифицирован).
  @override
  Future<String> signUpWithEmailAndPassword({
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
      
      // Сразу создаем документ в Firestore
      final newUser = UserModel(
        uid: result.user!.uid,
        name: name,
        email: email,
      );
      await _firestore.collection('users').doc(result.user!.uid).set(
        newUser.toMap(),
        SetOptions(merge: true),
      );
      
      await result.user!.sendEmailVerification();
    }
    return email;
  }

  // ──────────────────────────────────────────────
  // Google
  // ──────────────────────────────────────────────

  @override
  Future<UserModel?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = firebase.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final result = await _firebaseAuth.signInWithCredential(credential);
    if (result.user != null) {
      // Синхронизируем Google-профиль с Firestore
      await saveUserToFirestore();

      final userDoc =
          await _firestore.collection('users').doc(result.user!.uid).get();
      return UserModel.fromFirestore(userDoc);
    }
    return null;
  }

  // ──────────────────────────────────────────────
  // Verification
  // ──────────────────────────────────────────────

  @override
  Future<void> sendEmailVerification() async {
    await _firebaseAuth.currentUser?.sendEmailVerification();
  }

  @override
  Future<bool> checkEmailVerified() async {
    await _firebaseAuth.currentUser?.reload();
    return _firebaseAuth.currentUser?.emailVerified ?? false;
  }

  @override
  Future<void> deleteCurrentUser() async {
    await _firebaseAuth.currentUser?.delete();
  }

  // ──────────────────────────────────────────────
  // Firestore
  // ──────────────────────────────────────────────

  @override
  Future<void> saveUserToFirestore() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;

    final userModel = UserModel.fromFirebaseUser(user);
    await _firestore.collection('users').doc(user.uid).set(
          userModel.toMap(),
          SetOptions(merge: true),
        );
  }

  // ──────────────────────────────────────────────
  // Sign out
  // ──────────────────────────────────────────────

  @override
  Future<void> signOut() async {
    await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }
}
