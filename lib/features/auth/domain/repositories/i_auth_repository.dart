import '../entities/user_entity.dart';

/// Контракт репозитория аутентификации.
/// Только email/password — телефонная аутентификация убрана (платная).
abstract class IAuthRepository {
  /// Текущий залогиненный пользователь (синхронно из кэша Firebase)
  UserEntity? getCurrentUser();

  // Состояние аутентификации
  Stream<String?> get authStateChanges;

  // Вход по почте/паролю
  Future<UserEntity?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  // Регистрация
  Future<UserEntity?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  /// Выход из аккаунта
  Future<void> signOut();
}
