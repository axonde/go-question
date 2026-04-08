import 'package:go_question/core/errors/exception.dart';

enum NotificationExceptionType { notFound, fetchFailed, updateFailed }

abstract class NotificationException implements AppException {
  NotificationExceptionType get notificationType;
}

class NotificationNotFoundException extends BaseAppException
    implements NotificationException {
  @override
  final NotificationExceptionType notificationType =
      NotificationExceptionType.notFound;

  const NotificationNotFoundException()
    : super(type: AppExceptionType.firebaseFirestore);
}

class NotificationFetchException extends BaseAppException
    implements NotificationException {
  @override
  final NotificationExceptionType notificationType =
      NotificationExceptionType.fetchFailed;

  const NotificationFetchException()
    : super(type: AppExceptionType.firebaseFirestore);
}

class NotificationUpdateException extends BaseAppException
    implements NotificationException {
  @override
  final NotificationExceptionType notificationType =
      NotificationExceptionType.updateFailed;

  const NotificationUpdateException()
    : super(type: AppExceptionType.firebaseFirestore);
}
