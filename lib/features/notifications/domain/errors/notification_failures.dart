import 'package:go_question/core/errors/failures.dart' as core;

enum NotificationFailureType { notFound, fetchFailed, updateFailed }

class NotificationFailure implements core.Failure<NotificationFailureType> {
  @override
  final NotificationFailureType type;

  @override
  final String message;

  const NotificationFailure(this.type, {this.message = ''});
}
