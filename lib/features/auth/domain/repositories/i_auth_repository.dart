import '../user_entity.dart';

abstract class IAuthRepository {
  /// Получает закэшированного юзера при запуске
  UserEntity? getCurrentUser();

  /// Подписка на изменение стейта в Firebase
  Stream<String?> get authStateChanges;

  /// Авторизация по email/password
  Future<UserEntity?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Создание нового аккаунта по email/password
  Future<UserEntity?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Выход из аккаунта
  Future<void> signOut();
}
