import '../../../../core/errors/exception.dart';

final class AuthUserNotFoundException extends BaseAppException {
  const AuthUserNotFoundException()
    : super(type: AppExceptionType.firebaseAuth);
}

final class AuthInvalidCredentialsException extends BaseAppException {
  const AuthInvalidCredentialsException()
    : super(type: AppExceptionType.firebaseAuth);
}

final class AuthEmailAlreadyInUseException extends BaseAppException {
  const AuthEmailAlreadyInUseException()
    : super(type: AppExceptionType.validation);
}

final class AuthWeakPasswordException extends BaseAppException {
  const AuthWeakPasswordException() : super(type: AppExceptionType.validation);
}

final class AuthTooManyRequestsException extends BaseAppException {
  const AuthTooManyRequestsException()
    : super(type: AppExceptionType.firebaseAuth);
}
