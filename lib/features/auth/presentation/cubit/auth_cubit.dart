import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/i_auth_repository.dart';
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
    try {
      final user = await _repo.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user == null) {
        emit(const AuthError('Не удалось войти'));
        return;
      }
      if (!_repo.isCurrentUserEmailVerified()) {
        emit(AuthAwaitingVerification(user.email));
        return;
      }
      emit(AuthAuthenticated(user));
      _saveToFirestoreInBackground(); // не блокируем переход
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapError(e.code)));
    } catch (_) {
      emit(const AuthError('Произошла ошибка. Попробуйте снова.'));
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      final registeredEmail = await _repo.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
      // Письмо уже отправлено внутри datasource
      emit(
        AuthAwaitingVerification(
          registeredEmail,
          hint: 'Письмо отправлено на $registeredEmail',
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapError(e.code)));
    } catch (_) {
      emit(const AuthError('Произошла ошибка. Попробуйте снова.'));
    }
  }

  // ──────────────────────────────────────────────
  // Google
  // ──────────────────────────────────────────────

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final user = await _repo.signInWithGoogle();
      if (user == null) {
        // Пользователь закрыл окно Google
        emit(AuthInitial());
        return;
      }
      emit(AuthAuthenticated(user));
      _saveToFirestoreInBackground(); // не блокируем переход
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapError(e.code)));
    } catch (_) {
      emit(const AuthError('Не удалось войти через Google'));
    }
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
    try {
      final verified = await _repo.checkEmailVerified();
      if (verified) {
        final user = _repo.getCurrentUser();
        if (user != null) {
          emit(AuthAuthenticated(user));
          _saveToFirestoreInBackground(); // не блокируем переход
        } else {
          emit(const AuthError('Не удалось получить данные пользователя'));
        }
      } else {
        emit(
          AuthAwaitingVerification(
            currentEmail,
            hint: 'Почта ещё не подтверждена. Проверьте входящие.',
          ),
        );
      }
    } catch (_) {
      emit(AuthAwaitingVerification(currentEmail));
    }
  }

  /// Повторная отправка письма
  Future<void> resendVerificationEmail() async {
    final currentEmail = state is AuthAwaitingVerification
        ? (state as AuthAwaitingVerification).email
        : '';
    try {
      await _repo.sendEmailVerification();
      emit(
        AuthAwaitingVerification(
          currentEmail,
          hint: 'Письмо отправлено повторно на $currentEmail',
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthAwaitingVerification(currentEmail, hint: _mapError(e.code)));
    } catch (_) {
      emit(
        AuthAwaitingVerification(
          currentEmail,
          hint: 'Не удалось отправить письмо',
        ),
      );
    }
  }

  /// Удаляет незаверифицированный аккаунт → возврат к экрану регистрации
  Future<void> cancelVerification() async {
    try {
      await _repo.deleteCurrentUser();
    } catch (_) {
      // Игнорируем: если удаление не удалось, всё равно выходим
      await _repo.signOut();
    }
    emit(AuthInitial());
  }

  // ──────────────────────────────────────────────
  // Sign out
  // ──────────────────────────────────────────────

  Future<void> signOut() async {
    await _repo.signOut();
    emit(AuthInitial());
  }

  // ──────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────

  /// Сохраняет данные в Firestore в фоне, не блокируя UI.
  void _saveToFirestoreInBackground() {
    _repo.saveUserToFirestore().catchError((e) {
      // ignore: avoid_print
      print('[Firestore] Не удалось сохранить пользователя: $e');
    });
  }

  // ──────────────────────────────────────────────
  // Error mapping
  // ──────────────────────────────────────────────

  String _mapError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Пользователь не найден';
      case 'wrong-password':
        return 'Неверный пароль';
      case 'invalid-credential':
        return 'Неверный email или пароль';
      case 'email-already-in-use':
        return 'Этот email уже зарегистрирован';
      case 'invalid-email':
        return 'Некорректный email';
      case 'weak-password':
        return 'Слишком слабый пароль (минимум 6 символов)';
      case 'network-request-failed':
        return 'Нет подключения к интернету';
      case 'too-many-requests':
        return 'Слишком много попыток. Попробуйте позже';
      default:
        return 'Произошла ошибка. Попробуйте снова.';
    }
  }
}
