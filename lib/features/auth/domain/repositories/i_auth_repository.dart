import '../entities/user_entity.dart';

abstract class IAuthRepository {
  // Получить текущего пользователя
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

  // Вход по номеру телефона
  Future<void> signInWithPhoneNumber({
    required String phoneNumber,
    required Function(String code) onCodeSent,
    required Function(String error) onError,
  });

  // Выход
  Future<void> signOut();
}
