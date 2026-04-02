import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../models/user_model.dart';

/// Контракт удалённого источника данных.
/// Только email/password аутентификация.
abstract class IAuthRemoteDataSource {
  /// Текущая модель пользователя из кэша Firebase
  UserModel? getCurrentUser();

  /// Поток uid авторизованного пользователя
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

  /// Выход из аккаунта
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
      // Сохраняем displayName в Firebase Auth
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