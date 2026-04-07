import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/core/types/result.dart';

import '../../../../core/constants/auth_messages.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/services/auth_page_memory.dart';
import '../validators/auth_field_validators.dart';
import 'auth_state.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _repo;
  final AuthPageMemory _pageMemory;

  AuthBloc(this._repo, this._pageMemory) : super(const AuthState.initial()) {
    on<AuthStarted>(_onStarted);
    on<AuthPageChanged>(_onPageChanged);
    on<AuthLoginEmailChanged>(_onLoginEmailChanged);
    on<AuthLoginPasswordChanged>(_onLoginPasswordChanged);
    on<AuthSignUpNameChanged>(_onSignUpNameChanged);
    on<AuthSignUpEmailChanged>(_onSignUpEmailChanged);
    on<AuthSignUpPasswordChanged>(_onSignUpPasswordChanged);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthCheckEmailVerifiedRequested>(_onCheckEmailVerifiedRequested);
    on<AuthResendVerificationRequested>(_onResendVerificationRequested);
    on<AuthCancelVerificationRequested>(_onCancelVerificationRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthTransientCleared>(_onTransientCleared);
  }

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final savedPage = await _pageMemory.readLastPage();
    final user = _repo.getCurrentUser();

    if (user == null) {
      final pageToOpen = savedPage == AuthPage.verifyEmail
          ? AuthPage.signUp
          : savedPage;
      if (pageToOpen != savedPage) {
        await _pageMemory.saveLastPage(pageToOpen);
      }

      emit(_resetSessionState(page: pageToOpen));
      return;
    }

    if (_repo.isCurrentUserEmailVerified()) {
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearHint: true,
          clearError: true,
          clearVerificationEmail: true,
        ),
      );
      return;
    }

    await _setCurrentPage(emit, AuthPage.verifyEmail);
    emit(
      state.copyWith(
        status: AuthStatus.awaitingVerification,
        verificationEmail: user.email,
        clearHint: true,
        clearError: true,
      ),
    );
  }

  Future<void> _onPageChanged(
    AuthPageChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.page == AuthPage.verifyEmail && state.verificationEmail == null) {
      return;
    }

    await _setCurrentPage(emit, event.page);
    emit(
      state.copyWith(
        status: event.page == AuthPage.verifyEmail
            ? AuthStatus.awaitingVerification
            : AuthStatus.unauthenticated,
        clearHint: true,
        clearError: true,
      ),
    );
  }

  void _onLoginEmailChanged(
    AuthLoginEmailChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(loginEmail: event.value, clearError: true));
  }

  void _onLoginPasswordChanged(
    AuthLoginPasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(loginPassword: event.value, clearError: true));
  }

  void _onSignUpNameChanged(
    AuthSignUpNameChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(signUpName: event.value, clearError: true));
  }

  void _onSignUpEmailChanged(
    AuthSignUpEmailChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(signUpEmail: event.value, clearError: true));
  }

  void _onSignUpPasswordChanged(
    AuthSignUpPasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(signUpPassword: event.value, clearError: true));
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    final emailError = AuthFieldValidators.email(state.loginEmail);
    if (emailError != null) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          error: emailError,
          clearHint: true,
        ),
      );
      return;
    }

    final passwordError = AuthFieldValidators.password(state.loginPassword);
    if (passwordError != null) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          error: passwordError,
          clearHint: true,
        ),
      );
      return;
    }

    emit(_loadingState());

    final result = await _repo.signInWithEmailAndPassword(
      email: state.loginEmail.trim(),
      password: state.loginPassword,
    );

    await result.foldAsync(
      onSuccess: (user) async {
        if (user == null) {
          emit(
            state.copyWith(
              status: AuthStatus.failure,
              error: authSignInFailedMessage,
              clearHint: true,
            ),
          );
          return;
        }

        if (!_repo.isCurrentUserEmailVerified()) {
          await _setCurrentPage(emit, AuthPage.verifyEmail);
          emit(
            state.copyWith(
              status: AuthStatus.awaitingVerification,
              verificationEmail: user.email,
              clearError: true,
              clearHint: true,
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            clearError: true,
            clearHint: true,
            clearVerificationEmail: true,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            error: failure.message,
            clearHint: true,
          ),
        );
      },
    );
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    final nameError = AuthFieldValidators.name(state.signUpName);
    if (nameError != null) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          error: nameError,
          clearHint: true,
        ),
      );
      return;
    }

    final emailError = AuthFieldValidators.email(state.signUpEmail);
    if (emailError != null) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          error: emailError,
          clearHint: true,
        ),
      );
      return;
    }

    final passwordError = AuthFieldValidators.password(state.signUpPassword);
    if (passwordError != null) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          error: passwordError,
          clearHint: true,
        ),
      );
      return;
    }

    emit(_loadingState());

    final result = await _repo.signUpWithEmailAndPassword(
      email: state.signUpEmail.trim(),
      password: state.signUpPassword,
      name: state.signUpName.trim(),
    );

    await result.foldAsync(
      onSuccess: (registeredEmail) async {
        await _setCurrentPage(emit, AuthPage.verifyEmail);
        emit(
          state.copyWith(
            status: AuthStatus.awaitingVerification,
            verificationEmail: registeredEmail,
            hint: authVerificationEmailSentMessage(registeredEmail),
            clearError: true,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            error: failure.message,
            clearHint: true,
          ),
        );
      },
    );
  }

  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(_loadingState());

    final result = await _repo.signInWithGoogle();
    result.fold(
      onSuccess: (user) {
        if (user == null) {
          emit(
            state.copyWith(
              status: AuthStatus.unauthenticated,
              clearError: true,
              clearHint: true,
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            clearError: true,
            clearHint: true,
            clearVerificationEmail: true,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            error: failure.message,
            clearHint: true,
          ),
        );
      },
    );
  }

  Future<void> _onCheckEmailVerifiedRequested(
    AuthCheckEmailVerifiedRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentEmail = state.verificationEmail ?? '';
    emit(_loadingState());

    final result = await _repo.checkEmailVerified();
    result.fold(
      onSuccess: (verified) {
        if (verified) {
          final user = _repo.getCurrentUser();
          if (user == null) {
            emit(
              state.copyWith(
                status: AuthStatus.failure,
                error: authUserDataFetchFailedMessage,
                clearHint: true,
              ),
            );
            return;
          }

          emit(
            state.copyWith(
              status: AuthStatus.authenticated,
              user: user,
              clearError: true,
              clearHint: true,
              clearVerificationEmail: true,
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            status: AuthStatus.awaitingVerification,
            verificationEmail: currentEmail,
            hint: authEmailNotVerifiedYetMessage,
            clearError: true,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.awaitingVerification,
            verificationEmail: currentEmail,
            hint: failure.message,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onResendVerificationRequested(
    AuthResendVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentEmail = state.verificationEmail ?? '';

    emit(_loadingState());

    final result = await _repo.sendEmailVerification();
    result.fold(
      onSuccess: (_) {
        emit(
          state.copyWith(
            status: AuthStatus.awaitingVerification,
            verificationEmail: currentEmail,
            hint: authVerificationEmailResentMessage(currentEmail),
            clearError: true,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.awaitingVerification,
            verificationEmail: currentEmail,
            hint: failure.message,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onCancelVerificationRequested(
    AuthCancelVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Best-effort user deletion: proceed to sign out even if deletion fails.
    await _repo.deleteCurrentUser();

    final signOutResult = await _repo.signOut();
    await signOutResult.foldAsync(
      onSuccess: (_) async {
        final targetPage = state.lastPage == AuthPage.verifyEmail
            ? AuthPage.signUp
            : state.lastPage;

        await _setCurrentPage(emit, targetPage);
        emit(_resetSessionState(page: targetPage));
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            error: failure.message,
            clearHint: true,
          ),
        );
      },
    );
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _repo.signOut();
    result.fold(
      onSuccess: (_) {
        emit(_resetSessionState(page: AuthPage.login));
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            error: failure.message,
            clearHint: true,
          ),
        );
      },
    );
  }

  void _onTransientCleared(
    AuthTransientCleared event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(clearError: true, clearHint: true));
  }

  AuthState _loadingState() {
    return state.copyWith(
      status: AuthStatus.loading,
      clearError: true,
      clearHint: true,
    );
  }

  AuthState _resetSessionState({required AuthPage page}) {
    return state.copyWith(
      status: AuthStatus.unauthenticated,
      currentPage: page,
      lastPage: page,
      loginEmail: '',
      loginPassword: '',
      signUpName: '',
      signUpEmail: '',
      signUpPassword: '',
      clearUser: true,
      clearVerificationEmail: true,
      clearError: true,
      clearHint: true,
    );
  }

  Future<void> _setCurrentPage(Emitter<AuthState> emit, AuthPage page) async {
    await _pageMemory.saveLastPage(page);
    emit(state.copyWith(currentPage: page, lastPage: page));
  }
}
