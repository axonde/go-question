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
      return const AuthFailure(AuthFailureType.userNotFound);
    }
    if (error is AuthInvalidCredentialsException) {
      return const AuthFailure(AuthFailureType.invalidCredentials);
    }
    if (error is AuthEmailAlreadyInUseException) {
      return const AuthFailure(AuthFailureType.emailAlreadyInUse);
    }
    if (error is AuthWeakPasswordException) {
      return const AuthFailure(AuthFailureType.weakPassword);
    }
    if (error is AuthTooManyRequestsException) {
      return const AuthFailure(AuthFailureType.tooManyRequests);
    }

    final commonFailure = _commonMapper.map(error);
    return AuthFailure(_mapCommonFailure(commonFailure.type));
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
