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
    return AuthFailure(
      _mapCommonFailure(commonFailure.type),
      message: commonFailure.message,
    );
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
}
