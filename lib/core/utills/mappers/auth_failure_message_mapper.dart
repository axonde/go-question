import '../../../features/auth/domain/errors/auth_failure.dart';
import '../../constants/auth_messages.dart';

final class AuthFailureMessageMapper {
  const AuthFailureMessageMapper();

  String errorMessage(AuthFailure failure) {
    if (failure.message.isNotEmpty) {
      return failure.message;
    }

    switch (failure.type) {
      case AuthFailureType.server:
        return authSignInFailedMessage;
      case AuthFailureType.network:
        return authNoInternetMessage;
      case AuthFailureType.unauthorized:
        return authUserNotAuthorizedMessage;
      case AuthFailureType.validation:
        return authInvalidEmailMessage;
      case AuthFailureType.unknown:
        return authUnexpectedErrorMessage;
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
    }
  }

  String hintMessage(AuthFailure failure) => errorMessage(failure);
}
