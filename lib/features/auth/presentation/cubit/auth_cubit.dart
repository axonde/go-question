import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/i_auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IAuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial()) {
    _init();
  }

  // Инициализация: проверка текущего юзера
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
        password: password
      );
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthError('Не удалось войти'));
      }
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // Регистрация по email/password
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
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // Выход
  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(AuthInitial());
  }

  // --- Заглушки для телефона (для напарника) ---

  Future<void> verifyPhone(String phone) async {
    emit(AuthLoading());
    // TODO: логика напарника
  }

  Future<void> submitSmsCode(String code) async {
    emit(AuthLoading());
    // TODO: логика напарника
  }
}
