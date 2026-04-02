import 'package:equatable/equatable.dart';
import 'package:go_question/features/user/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние — пользователь не авторизован
class AuthInitial extends AuthState {}

/// Идёт загрузка (запрос к Firebase)
class AuthLoading extends AuthState {}

/// Пользователь успешно авторизован
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Ошибка аутентификации
class AuthError extends AuthState {
  final String error;

  const AuthError(this.error);

  @override
  List<Object?> get props => [error];
}
