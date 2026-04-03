enum AppExceptionType {
  network,
  timeout,
  firebaseAuth,
  firebaseFirestore,
  serialization,
  cache,
  unauthorized,
  validation,
  unknown,
}

abstract interface class AppException implements Exception {
  AppExceptionType get type;
  String get message;
}

class BaseAppException implements AppException {
  @override
  final AppExceptionType type;

  @override
  final String message;

  const BaseAppException({required this.type, String? message})
    : message = message ?? 'Unexpected exception occurred';

  @override
  String toString() => 'BaseAppException(type: $type, message: $message)';
}

final class NetworkException extends BaseAppException {
  const NetworkException({super.message})
    : super(type: AppExceptionType.network);
}

final class ServerException extends BaseAppException {
  const ServerException({super.message})
    : super(type: AppExceptionType.firebaseFirestore);
}

final class AuthException extends BaseAppException {
  const AuthException({super.message})
    : super(type: AppExceptionType.firebaseAuth);
}

final class ValidationException extends BaseAppException {
  const ValidationException({super.message})
    : super(type: AppExceptionType.validation);
}

final class UnknownException extends BaseAppException {
  const UnknownException({super.message})
    : super(type: AppExceptionType.unknown);
}
