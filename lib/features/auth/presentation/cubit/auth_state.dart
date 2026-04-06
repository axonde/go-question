import '../../domain/entities/registration_input_entity.dart';

abstract class AuthState {
  const AuthState();
}

/// Начальное состояние — пользователь не авторизован
class AuthInitial extends AuthState {}

/// Идёт загрузка
class AuthLoading extends AuthState {}

/// Пользователь успешно авторизован и верифицирован
class AuthAuthenticated extends AuthState {
  final RegistrationInput user;
  const AuthAuthenticated(this.user);
}

/// Пользователь зарегистрировался, ждём подтверждения почты.
/// [hint] — опциональное сообщение для показа в snackbar (например, «Письмо отправлено»)
class AuthAwaitingVerification extends AuthState {
  final String email;
  final String? hint;
  const AuthAwaitingVerification(this.email, {this.hint});
}

/// Ошибка аутентификации
class AuthError extends AuthState {
  final String error;
  const AuthError(this.error);
}
