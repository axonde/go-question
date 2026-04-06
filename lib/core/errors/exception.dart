abstract interface class AppException implements Exception {
  AppExceptionType get type;
}

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

class BaseAppException implements AppException {
  @override
  final AppExceptionType type;

  const BaseAppException({required this.type});

  @override
  String toString() => 'BaseAppException(type: $type)';
}

final class NetworkException extends BaseAppException {
  const NetworkException() : super(type: AppExceptionType.network);
}

final class ServerException extends BaseAppException {
  const ServerException() : super(type: AppExceptionType.firebaseFirestore);
}

final class AuthException extends BaseAppException {
  const AuthException() : super(type: AppExceptionType.firebaseAuth);
}

final class ValidationException extends BaseAppException {
  const ValidationException() : super(type: AppExceptionType.validation);
}

final class UnknownException extends BaseAppException {
  const UnknownException() : super(type: AppExceptionType.unknown);
}
