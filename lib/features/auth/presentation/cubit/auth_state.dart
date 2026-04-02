import '../../domain/entities/user_entity.dart';

abstract class AuthState {
  const AuthState();
}

/// Начальное состояние — пользователь не авторизован
class AuthInitial extends AuthState {}

/// Идёт загрузка (запрос к Firebase)
class AuthLoading extends AuthState {}

/// Пользователь успешно авторизован
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);
}

/// Ошибка аутентификации
class AuthError extends AuthState {
  final String error;

  const AuthError(this.error);
}
