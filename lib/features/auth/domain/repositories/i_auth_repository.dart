import 'package:go_question/features/user/domain/entities/user_entity.dart';

/// Контракт репозитория аутентификации.
/// Только email/password — телефонная аутентификация убрана (платная).
abstract class IAuthRepository {
  /// Текущий авторизованный пользователь (если есть)
  UserEntity? getCurrentUser();

  /// Вход по почте и паролю
  Future<UserEntity?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Регистрация по почте, паролю и имени
  Future<UserEntity?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  /// Выход
  Future<void> signOut();
}
