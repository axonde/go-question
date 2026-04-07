part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

final class AuthPageChanged extends AuthEvent {
  final AuthPage page;

  const AuthPageChanged(this.page);
}

final class AuthLoginEmailChanged extends AuthEvent {
  final String value;

  const AuthLoginEmailChanged(this.value);
}

final class AuthLoginPasswordChanged extends AuthEvent {
  final String value;

  const AuthLoginPasswordChanged(this.value);
}

final class AuthSignUpNameChanged extends AuthEvent {
  final String value;

  const AuthSignUpNameChanged(this.value);
}

final class AuthSignUpEmailChanged extends AuthEvent {
  final String value;

  const AuthSignUpEmailChanged(this.value);
}

final class AuthSignUpPasswordChanged extends AuthEvent {
  final String value;

  const AuthSignUpPasswordChanged(this.value);
}

final class AuthSignInRequested extends AuthEvent {
  const AuthSignInRequested();
}

final class AuthSignUpRequested extends AuthEvent {
  const AuthSignUpRequested();
}

final class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested();
}

final class AuthCheckEmailVerifiedRequested extends AuthEvent {
  const AuthCheckEmailVerifiedRequested();
}

final class AuthResendVerificationRequested extends AuthEvent {
  const AuthResendVerificationRequested();
}

final class AuthCancelVerificationRequested extends AuthEvent {
  const AuthCancelVerificationRequested();
}

final class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

final class AuthTransientCleared extends AuthEvent {
  const AuthTransientCleared();
}
