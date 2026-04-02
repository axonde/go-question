import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:go_question/features/user/data/models/user_model.dart';

/// Контракт удалённого источника данных.
/// Только email/password аутентификация.
abstract class IAuthRemoteDataSource {
  /// Получает информацию об авторизованном пользователи напрямую из Firebase Auth
  UserModel? getCurrentUser();

  /// Вход по почте и паролю
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Регистрация и автоматическое логирование
  Future<UserModel?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  /// Выход
  Future<void> signOut();
}

/// Реализация через Firebase Auth
class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  final firebase.FirebaseAuth _auth;

  AuthRemoteDataSourceImpl(this._auth);

  @override
  UserModel? getCurrentUser() {
    final user = _auth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user != null ? UserModel.fromFirebaseUser(credential.user!) : null;
  }

  @override
  Future<UserModel?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user != null) {
      // Обновляет displayName в профиле Firebase Auth
      await credential.user!.updateDisplayName(name);
      return UserModel.fromFirebaseUser(credential.user!);
    }
    return null;
  }

  @override
  Future<void> signOut() {
    return _auth.signOut();
  }
}