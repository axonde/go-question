import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/domain/errors/event_failures.dart';

abstract interface class IEventsRepository {
  Future<Result<List<EventEntity>, EventFailure>> getEvents();
  Stream<List<EventEntity>> watchEvents();
  Future<Result<EventEntity, EventFailure>> getEventById(String id);
  Future<Result<void, EventFailure>> createEvent(EventEntity event);
  Future<Result<void, EventFailure>> updateEvent(EventEntity event);
  Future<Result<void, EventFailure>> deleteEvent(String id);
  Future<Result<void, EventFailure>> requestJoinEvent({
    required String eventId,
    required String requesterId,
  });
  Future<Result<void, EventFailure>> approveJoinRequest({
    required String requestId,
    required String organizerId,
  });
  Future<Result<void, EventFailure>> rejectJoinRequest({
    required String requestId,
    required String organizerId,
  });
  Future<Result<void, EventFailure>> leaveEvent({
    required String eventId,
    required String userId,
  });
  Future<Result<void, EventFailure>> removeParticipant({
    required String eventId,
    required String userId,
  });
}
