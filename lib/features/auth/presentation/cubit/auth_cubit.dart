import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:go_question/features/auth/presentation/cubit/auth_state.dart';

/// Управляет состоянием аутентификации.
/// Поддерживает только email/password вход и регистрацию.
class AuthCubit extends Cubit<AuthState> {
  final IAuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial()) {
    _init();
  }

  /// Проверяет при запуске — возможно пользователь уже залогинен
  void _init() {
    final user = _authRepository.getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthInitial());
    }
  }

  // Вход по email/password
  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthError('Не удалось войти'));
      }
    } catch (e) {
      emit(AuthError(_mapFirebaseError(e.toString())));
    }
  }

  /// Регистрация по email, паролю и имени
  Future<void> signUp(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthError('Не удалось зарегистрироваться'));
      }
    } catch (e) {
      emit(AuthError(_mapFirebaseError(e.toString())));
    }
  }

  /// Выход из аккаунта
  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(AuthInitial());
  }

  /// Переводит технические ошибки Firebase в понятные пользователю сообщения
  String _mapFirebaseError(String error) {
    if (error.contains('user-not-found')) return 'Пользователь не найден';
    if (error.contains('wrong-password')) return 'Неверный пароль';
    if (error.contains('email-already-in-use')) return 'Email уже используется';
    if (error.contains('invalid-email')) return 'Некорректный email';
    if (error.contains('weak-password')) return 'Слишком слабый пароль (минимум 6 символов)';
    if (error.contains('network-request-failed')) return 'Нет подключения к интернету';
    return 'Произошла ошибка. Попробуйте снова.';
  }
}
