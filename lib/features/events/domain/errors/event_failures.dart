import 'package:go_question/core/errors/failures.dart' as core;

enum EventFailureType {
  notFound,
  creationFailed,
  updateFailed,
  deletionFailed,
  fetchFailed,
}

class EventFailure implements core.Failure<EventFailureType> {
  @override
  final EventFailureType type;

  @override
  final String message;

  const EventFailure(this.type, {this.message = ''});
}
