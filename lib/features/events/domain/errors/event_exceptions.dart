import 'package:go_question/core/errors/exception.dart';

enum EventExceptionType {
  notFound,
  creationFailed,
  updateFailed,
  deletionFailed,
  fetchFailed,
}

abstract class EventException implements AppException {
  EventExceptionType get eventType;
}

class EventNotFoundException extends BaseAppException
    implements EventException {
  @override
  final EventExceptionType eventType = EventExceptionType.notFound;

  const EventNotFoundException()
    : super(type: AppExceptionType.firebaseFirestore);
}

class EventFetchException extends BaseAppException implements EventException {
  @override
  final EventExceptionType eventType = EventExceptionType.fetchFailed;

  const EventFetchException() : super(type: AppExceptionType.firebaseFirestore);
}

class EventCreationException extends BaseAppException
    implements EventException {
  @override
  final EventExceptionType eventType = EventExceptionType.creationFailed;

  const EventCreationException()
    : super(type: AppExceptionType.firebaseFirestore);
}

class EventUpdateException extends BaseAppException implements EventException {
  @override
  final EventExceptionType eventType = EventExceptionType.updateFailed;

  const EventUpdateException()
    : super(type: AppExceptionType.firebaseFirestore);
}

class EventDeletionException extends BaseAppException
    implements EventException {
  @override
  final EventExceptionType eventType = EventExceptionType.deletionFailed;

  const EventDeletionException()
    : super(type: AppExceptionType.firebaseFirestore);
}
