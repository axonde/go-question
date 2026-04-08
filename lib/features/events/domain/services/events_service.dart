import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/domain/errors/event_failures.dart';
import 'package:go_question/features/events/domain/repositories/i_events_repository.dart';

class EventsService {
  final IEventsRepository _repository;

  const EventsService(this._repository);

  Future<Result<List<EventEntity>, EventFailure>> getEvents() {
    return _repository.getEvents();
  }

  Future<Result<EventEntity, EventFailure>> getEventById(String id) {
    return _repository.getEventById(id);
  }

  Future<Result<void, EventFailure>> createEvent(EventEntity event) {
    return _repository.createEvent(event);
  }

  Future<Result<void, EventFailure>> updateEvent(EventEntity event) {
    return _repository.updateEvent(event);
  }

  Future<Result<void, EventFailure>> deleteEvent(String id) {
    return _repository.deleteEvent(id);
  }
}
