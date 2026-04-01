import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../../../core/network/network_info.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IAuthRepository _authRepository;
  final NetworkInfo _networkInfo;

  AuthCubit(this._authRepository, this._networkInfo) : super(AuthInitial());

  // Проверяет закэшированного юзера при старте приложения
  void checkAuthStatus() {
    final user = _authRepository.getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(userId: user.id, email: user.email));
    } else {
      emit(AuthInitial());
    }
  }

  // Вход
  Future<void> signIn(String email, String password) async {
    if (!await _networkInfo.isConnected) {
      emit(const AuthError('Отсутствует подключение к интернету'));
      return;
    }

    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      if (user != null) {
        emit(AuthAuthenticated(userId: user.id, email: user.email));
      } else {
        emit(const AuthError('ОШИБКА: Пользователь не возвращен'));
      }
    } catch (e) {
      // replaceAll чтобы скрыть техническое слово Exception:
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // Регистрация
  Future<void> signUp(String email, String password) async {
    if (!await _networkInfo.isConnected) {
      emit(const AuthError('Отсутствует подключение к интернету'));
      return;
    }

    emit(AuthLoading());
    try {
      final user = await _authRepository.signUpWithEmailAndPassword(
        email: email, 
        password: password
      );
      if (user != null) {
        emit(AuthAuthenticated(userId: user.id, email: user.email));
      } else {
        emit(const AuthError('ОШИБКА: Пользователь не возвращен'));
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
}
