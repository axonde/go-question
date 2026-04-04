import 'exception.dart';
import 'failures.dart';

abstract interface class ExceptionToFailureMapper<F> {
  F map(Object error);
}

final class DefaultExceptionToFailureMapper
    implements ExceptionToFailureMapper<GlobalFailure> {
  const DefaultExceptionToFailureMapper();

  @override
  GlobalFailure map(Object error) {
    if (error is! AppException) {
      return GlobalFailure.fromType(AppFailureType.unknownError);
    }

    final failureType = _mapAppExceptionType(error.type);
    return GlobalFailure.fromType(failureType);
  }
}

GlobalFailure mapExceptionToFailure(Object error) {
  return const DefaultExceptionToFailureMapper().map(error);
}

AppFailureType _mapAppExceptionType(AppExceptionType type) {
  switch (type) {
    case AppExceptionType.network:
    case AppExceptionType.timeout:
      return AppFailureType.connectionError;
    case AppExceptionType.firebaseFirestore:
      return AppFailureType.serverError;
    case AppExceptionType.firebaseAuth:
    case AppExceptionType.unauthorized:
      return AppFailureType.unauthorizedError;
    case AppExceptionType.serialization:
    case AppExceptionType.validation:
      return AppFailureType.validationError;
    case AppExceptionType.cache:
      return AppFailureType.cacheUpdateError;
    case AppExceptionType.unknown:
      return AppFailureType.unknownError;
  }
}
