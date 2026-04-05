import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/auth_messages.dart';
import '../../../../core/types/result.dart';
import '../../domain/repositories/i_auth_repository.dart';
import 'auth_failure_message_mapper.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IAuthRepository _repo;

  AuthCubit(this._repo) : super(AuthInitial()) {
    _init();
  }

  // ──────────────────────────────────────────────
  // Init — восстановление сессии при перезапуске
  // ──────────────────────────────────────────────

  void _init() {
    final user = _repo.getCurrentUser();
    if (user == null) {
      emit(AuthInitial());
      return;
    }
    if (_repo.isCurrentUserEmailVerified()) {
      emit(AuthAuthenticated(user));
    } else {
      // Аккаунт есть, но почта не подтверждена
      emit(AuthAwaitingVerification(user.email));
    }
  }

  // ──────────────────────────────────────────────
  // Email / password
  // ──────────────────────────────────────────────

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    final result = await _repo.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    result.fold(
      onSuccess: (user) {
        if (user == null) {
          emit(const AuthError(authSignInFailedMessage));
          return;
        }
        if (!_repo.isCurrentUserEmailVerified()) {
          emit(AuthAwaitingVerification(user.email));
          return;
        }
        emit(AuthAuthenticated(user));
      },
      onFailure: (failure) {
        emit(AuthError(mapAuthFailureToMessage(failure)));
      },
    );
  }

  Future<void> signUp(String email, String password, String name) async {
    emit(AuthLoading());
    final result = await _repo.signUpWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );
    result.fold(
      onSuccess: (registeredEmail) {
        emit(
          AuthAwaitingVerification(
            registeredEmail,
            hint: authVerificationEmailSentMessage(registeredEmail),
          ),
        );
      },
      onFailure: (failure) {
        emit(AuthError(mapAuthFailureToMessage(failure)));
      },
    );
  }

  // ──────────────────────────────────────────────
  // Google
  // ──────────────────────────────────────────────

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    final result = await _repo.signInWithGoogle();
    result.fold(
      onSuccess: (user) {
        if (user == null) {
          // Пользователь закрыл окно Google
          emit(AuthInitial());
          return;
        }
        emit(AuthAuthenticated(user));
      },
      onFailure: (failure) {
        emit(AuthError(mapAuthFailureToMessage(failure)));
      },
    );
  }

  // ──────────────────────────────────────────────
  // Verification
  // ──────────────────────────────────────────────

  /// Проверяет, подтвердил ли пользователь почту (кнопка «Я подтвердил»)
  Future<void> checkEmailVerified() async {
    final currentEmail = state is AuthAwaitingVerification
        ? (state as AuthAwaitingVerification).email
        : '';
    emit(AuthLoading());
    final result = await _repo.checkEmailVerified();
    result.fold(
      onSuccess: (verified) {
        if (verified) {
          final user = _repo.getCurrentUser();
          if (user != null) {
            emit(AuthAuthenticated(user));
          } else {
            emit(const AuthError(authUserDataFetchFailedMessage));
          }
        } else {
          emit(
            AuthAwaitingVerification(
              currentEmail,
              hint: authEmailNotVerifiedYetMessage,
            ),
          );
        }
      },
      onFailure: (failure) {
        emit(
          AuthAwaitingVerification(
            currentEmail,
            hint: mapAuthFailureToMessage(failure),
          ),
        );
      },
    );
  }

  /// Повторная отправка письма
  Future<void> resendVerificationEmail() async {
    final currentEmail = state is AuthAwaitingVerification
        ? (state as AuthAwaitingVerification).email
        : '';
    final result = await _repo.sendEmailVerification();
    result.fold(
      onSuccess: (_) {
        emit(
          AuthAwaitingVerification(
            currentEmail,
            hint: authVerificationEmailResentMessage(currentEmail),
          ),
        );
      },
      onFailure: (failure) {
        emit(
          AuthAwaitingVerification(
            currentEmail,
            hint: mapAuthFailureToMessage(failure),
          ),
        );
      },
    );
  }

  /// Удаляет незаверифицированный аккаунт → возврат к экрану регистрации
  Future<void> cancelVerification() async {
    final deleteResult = await _repo.deleteCurrentUser();
    deleteResult.fold(onSuccess: (_) {}, onFailure: (_) {});
    await _repo.signOut();
    emit(AuthInitial());
  }

  // ──────────────────────────────────────────────
  // Sign out
  // ──────────────────────────────────────────────

  Future<void> signOut() async {
    final result = await _repo.signOut();
    result.fold(
      onSuccess: (_) {
        emit(AuthInitial());
      },
      onFailure: (failure) {
        emit(AuthError(mapAuthFailureToMessage(failure)));
      },
    );
  }
}
