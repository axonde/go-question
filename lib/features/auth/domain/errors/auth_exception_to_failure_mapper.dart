import '../../../../core/constants/auth_messages.dart';
import '../../../../core/errors/exception_to_failure_mapper.dart';
import '../../../../core/errors/failures.dart';
import 'auth_exception.dart';
import 'auth_failure.dart';

abstract interface class AuthExceptionToFailureMapper
    implements ExceptionToFailureMapper<AuthFailure> {}

final class AuthExceptionToFailureMapperImpl
    implements AuthExceptionToFailureMapper {
  final ExceptionToFailureMapper<GlobalFailure> _commonMapper;

  const AuthExceptionToFailureMapperImpl({
    ExceptionToFailureMapper<GlobalFailure> commonMapper =
        const DefaultExceptionToFailureMapper(),
  }) : _commonMapper = commonMapper;

  @override
  AuthFailure map(Object error) {
    if (error is AuthUserNotFoundException) {
      return const AuthFailure(
        AuthFailureType.userNotFound,
        message: authUserNotFoundMessage,
      );
    }
    if (error is AuthInvalidCredentialsException) {
      return const AuthFailure(
        AuthFailureType.invalidCredentials,
        message: authInvalidCredentialsMessage,
      );
    }
    if (error is AuthEmailAlreadyInUseException) {
      return const AuthFailure(
        AuthFailureType.emailAlreadyInUse,
        message: authEmailAlreadyInUseMessage,
      );
    }
    if (error is AuthWeakPasswordException) {
      return const AuthFailure(
        AuthFailureType.weakPassword,
        message: authWeakPasswordMessage,
      );
    }
    if (error is AuthTooManyRequestsException) {
      return const AuthFailure(
        AuthFailureType.tooManyRequests,
        message: authTooManyRequestsMessage,
      );
    }

    final commonFailure = _commonMapper.map(error);
    final mappedType = _mapCommonFailure(commonFailure.type);
    final mappedMessage = commonFailure.message.isNotEmpty
        ? commonFailure.message
        : _defaultMessageFor(mappedType);

    return AuthFailure(mappedType, message: mappedMessage);
  }

  AuthFailureType _mapCommonFailure(AppFailureType type) {
    switch (type) {
      case AppFailureType.serverError:
        return AuthFailureType.server;
      case AppFailureType.connectionError:
        return AuthFailureType.network;
      case AppFailureType.unauthorizedError:
        return AuthFailureType.unauthorized;
      case AppFailureType.validationError:
        return AuthFailureType.validation;
      case AppFailureType.unknownError:
        return AuthFailureType.unknown;
      case AppFailureType.cacheUpdateError:
      case AppFailureType.emailAlreadyInUseError:
      case AppFailureType.userNotFoundError:
      case AppFailureType.authOperationError:
        return AuthFailureType.unknown;
    }
  }

  String _defaultMessageFor(AuthFailureType type) {
    switch (type) {
      case AuthFailureType.network:
        return authNoInternetMessage;
      case AuthFailureType.unauthorized:
        return authUserNotAuthorizedMessage;
      case AuthFailureType.validation:
        return authInvalidEmailMessage;
      case AuthFailureType.server:
      case AuthFailureType.unknown:
      case AuthFailureType.userNotFound:
      case AuthFailureType.invalidCredentials:
      case AuthFailureType.emailAlreadyInUse:
      case AuthFailureType.weakPassword:
      case AuthFailureType.tooManyRequests:
        return authUnexpectedErrorMessage;
    }
  }
}
