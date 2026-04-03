import 'exception.dart';
import 'failures.dart';

Failure mapExceptionToFailure(Object error) {
  if (error is AppException) {
    return Failure.fromType(
      _mapAppExceptionType(error.type),
      message: error.message,
    );
  }

  return Failure.fromType(FailureType.unknownError);
}

FailureType _mapAppExceptionType(AppExceptionType type) {
  switch (type) {
    case AppExceptionType.network:
    case AppExceptionType.timeout:
      return FailureType.connectionError;
    case AppExceptionType.firebaseFirestore:
      return FailureType.serverError;
    case AppExceptionType.firebaseAuth:
    case AppExceptionType.unauthorized:
      return FailureType.unauthorizedError;
    case AppExceptionType.serialization:
    case AppExceptionType.validation:
      return FailureType.validationError;
    case AppExceptionType.cache:
      return FailureType.cacheUpdateError;
    case AppExceptionType.unknown:
      return FailureType.unknownError;
  }
}
