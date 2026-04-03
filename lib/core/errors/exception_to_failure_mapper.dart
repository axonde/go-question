import '../constants/messages.dart';
import 'exception.dart';
import 'failures.dart';

Failure mapExceptionToFailure(Object error) {
  if (error is! AppException) {
    return Failure.fromType(FailureType.unknownError);
  }

  final failureType = _mapAppExceptionType(error.type);
  final specificMessage = _extractSpecificExceptionMessage(error.message);

  if (specificMessage == null) {
    return Failure.fromType(failureType);
  }

  return Failure.fromType(failureType, message: specificMessage);
}

String? _extractSpecificExceptionMessage(String message) {
  final normalized = message.trim();
  if (normalized.isEmpty || normalized == unexpectedExceptionMessage) {
    return null;
  }

  return normalized;
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
