import '../../../../core/constants/auth_messages.dart';
import '../../domain/errors/auth_failure.dart';

String mapAuthFailureToMessage(AuthFailure failure) {
  switch (failure.type) {
    case AuthFailureType.userNotFound:
      return authUserNotFoundMessage;
    case AuthFailureType.invalidCredentials:
      return authInvalidCredentialsMessage;
    case AuthFailureType.emailAlreadyInUse:
      return authEmailAlreadyInUseMessage;
    case AuthFailureType.weakPassword:
      return authWeakPasswordMessage;
    case AuthFailureType.tooManyRequests:
      return authTooManyRequestsMessage;
    case AuthFailureType.network:
      return authNoInternetMessage;
    case AuthFailureType.unauthorized:
      return authUserNotAuthorizedMessage;
    case AuthFailureType.validation:
      return authInvalidEmailMessage;
    case AuthFailureType.server:
      return authSignInFailedMessage;
    case AuthFailureType.unknown:
      return authUnexpectedErrorMessage;
  }
}
