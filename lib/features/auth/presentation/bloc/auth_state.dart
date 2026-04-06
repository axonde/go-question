import '../../domain/entities/registration_input_entity.dart';

enum AuthPage { login, signIn, verifyEmail }

enum AuthStatus {
  initial,
  loading,
  unauthenticated,
  awaitingVerification,
  authenticated,
  failure,
}

class AuthState {
  final AuthStatus status;
  final AuthPage currentPage;
  final AuthPage lastPage;
  final String loginEmail;
  final String loginPassword;
  final String signUpName;
  final String signUpEmail;
  final String signUpPassword;
  final RegistrationInput? user;
  final String? verificationEmail;
  final String? hint;
  final String? errorMessage;

  const AuthState({
    required this.status,
    required this.currentPage,
    required this.lastPage,
    required this.loginEmail,
    required this.loginPassword,
    required this.signUpName,
    required this.signUpEmail,
    required this.signUpPassword,
    this.user,
    this.verificationEmail,
    this.hint,
    this.errorMessage,
  });

  const AuthState.initial()
    : status = AuthStatus.initial,
      currentPage = AuthPage.signIn,
      lastPage = AuthPage.signIn,
      loginEmail = '',
      loginPassword = '',
      signUpName = '',
      signUpEmail = '',
      signUpPassword = '',
      user = null,
      verificationEmail = null,
      hint = null,
      errorMessage = null;

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    AuthPage? currentPage,
    AuthPage? lastPage,
    String? loginEmail,
    String? loginPassword,
    String? signUpName,
    String? signUpEmail,
    String? signUpPassword,
    RegistrationInput? user,
    String? verificationEmail,
    String? hint,
    String? error,
    bool clearHint = false,
    bool clearError = false,
    bool clearUser = false,
    bool clearVerificationEmail = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      loginEmail: loginEmail ?? this.loginEmail,
      loginPassword: loginPassword ?? this.loginPassword,
      signUpName: signUpName ?? this.signUpName,
      signUpEmail: signUpEmail ?? this.signUpEmail,
      signUpPassword: signUpPassword ?? this.signUpPassword,
      user: clearUser ? null : (user ?? this.user),
      verificationEmail: clearVerificationEmail
          ? null
          : (verificationEmail ?? this.verificationEmail),
      hint: clearHint ? null : (hint ?? this.hint),
      errorMessage: clearError ? null : (error ?? errorMessage),
    );
  }
}
