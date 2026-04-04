import '../constants/messages.dart';

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
    : message = message ?? unexpectedExceptionMessage;

  @override
  String toString() => 'BaseAppException(type: $type, message: $message)';
}

final class NetworkException extends BaseAppException {
  const NetworkException({String? message})
    : super(
        type: AppExceptionType.network,
        message: message ?? networkExceptionMessage,
      );
}

final class ServerException extends BaseAppException {
  const ServerException({String? message})
    : super(
        type: AppExceptionType.firebaseFirestore,
        message: message ?? serverExceptionMessage,
      );
}

final class AuthException extends BaseAppException {
  const AuthException({String? message})
    : super(
        type: AppExceptionType.firebaseAuth,
        message: message ?? authExceptionMessage,
      );
}

final class ValidationException extends BaseAppException {
  const ValidationException({String? message})
    : super(
        type: AppExceptionType.validation,
        message: message ?? validationExceptionMessage,
      );
}

final class UnknownException extends BaseAppException {
  const UnknownException({String? message})
    : super(
        type: AppExceptionType.unknown,
        message: message ?? unexpectedExceptionMessage,
      );
}
