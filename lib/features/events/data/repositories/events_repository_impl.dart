import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/events/data/source/events_remote_data_source.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/domain/errors/event_exceptions.dart';
import 'package:go_question/features/events/domain/errors/event_failures.dart';
import 'package:go_question/features/events/domain/repositories/i_events_repository.dart';

class EventsRepositoryImpl implements IEventsRepository {
  final IEventsRemoteDataSource _remoteDataSource;
  final Map<String, EventEntity> _eventCache = {};
  List<EventEntity> _eventsCache = const [];

  EventsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<EventEntity>, EventFailure>> getEvents() async {
    try {
      final events = await _remoteDataSource.getEvents();
      _eventsCache = events;
      for (final event in events) {
        _eventCache[event.id] = event;
      }
      return Success(events);
    } on EventFetchException {
      if (_eventsCache.isNotEmpty) {
        return Success(_eventsCache);
      }
      return const Failure(EventFailure(EventFailureType.fetchFailed));
    } catch (_) {
      if (_eventsCache.isNotEmpty) {
        return Success(_eventsCache);
      }
      return const Failure(EventFailure(EventFailureType.fetchFailed));
    }
  }

  @override
  Stream<List<EventEntity>> watchEvents() {
    return _remoteDataSource.watchEvents().map((events) {
      _eventsCache = events;
      for (final event in events) {
        _eventCache[event.id] = event;
      }
      return events;
    });
  }

  @override
  Future<Result<EventEntity, EventFailure>> getEventById(String id) async {
    try {
      final event = await _remoteDataSource.getEventById(id);
      _eventCache[id] = event;
      return Success(event);
    } on EventNotFoundException {
      final cached = _eventCache[id];
      if (cached != null) {
        return Success(cached);
      }
      return const Failure(EventFailure(EventFailureType.notFound));
    } on EventFetchException {
      final cached = _eventCache[id];
      if (cached != null) {
        return Success(cached);
      }
      return const Failure(EventFailure(EventFailureType.fetchFailed));
    } catch (_) {
      final cached = _eventCache[id];
      if (cached != null) {
        return Success(cached);
      }
      return const Failure(EventFailure(EventFailureType.fetchFailed));
    }
  }

  @override
  Future<Result<void, EventFailure>> createEvent(EventEntity event) async {
    try {
      await _remoteDataSource.createEvent(event);
      _eventCache[event.id] = event;
      _eventsCache = [..._eventsCache, event]
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
      return const Success(null);
    } on EventCreationException {
      return const Failure(EventFailure(EventFailureType.creationFailed));
    } catch (_) {
      return const Failure(EventFailure(EventFailureType.creationFailed));
    }
  }

  @override
  Future<Result<void, EventFailure>> updateEvent(EventEntity event) async {
    try {
      await _remoteDataSource.updateEvent(event);
      _eventCache[event.id] = event;
      _eventsCache =
          _eventsCache
              .map((item) => item.id == event.id ? event : item)
              .toList()
            ..sort((a, b) => a.startTime.compareTo(b.startTime));
      return const Success(null);
    } on EventNotFoundException {
      return const Failure(EventFailure(EventFailureType.notFound));
    } on EventUpdateException {
      return const Failure(EventFailure(EventFailureType.updateFailed));
    } catch (_) {
      return const Failure(EventFailure(EventFailureType.updateFailed));
    }
  }

  @override
  Future<Result<void, EventFailure>> deleteEvent(String id) async {
    try {
      await _remoteDataSource.deleteEvent(id);
      _eventCache.remove(id);
      _eventsCache = _eventsCache.where((event) => event.id != id).toList();
      return const Success(null);
    } on EventNotFoundException {
      return const Failure(EventFailure(EventFailureType.notFound));
    } on EventDeletionException {
      return const Failure(EventFailure(EventFailureType.deletionFailed));
    } catch (_) {
      return const Failure(EventFailure(EventFailureType.deletionFailed));
    }
  }

  @override
  Future<Result<void, EventFailure>> requestJoinEvent({
    required String eventId,
    required String requesterId,
  }) async {
    try {
      await _remoteDataSource.requestJoinEvent(
        eventId: eventId,
        requesterId: requesterId,
      );
      return const Success(null);
    } catch (_) {
      return const Failure(EventFailure(EventFailureType.updateFailed));
    }
  }

  @override
  Future<Result<void, EventFailure>> approveJoinRequest({
    required String requestId,
    required String organizerId,
  }) async {
    try {
      await _remoteDataSource.approveJoinRequest(
        requestId: requestId,
        organizerId: organizerId,
      );
      return const Success(null);
    } catch (_) {
      return const Failure(EventFailure(EventFailureType.updateFailed));
    }
  }

  @override
  Future<Result<void, EventFailure>> rejectJoinRequest({
    required String requestId,
    required String organizerId,
  }) async {
    try {
      await _remoteDataSource.rejectJoinRequest(
        requestId: requestId,
        organizerId: organizerId,
      );
      return const Success(null);
    } catch (_) {
      return const Failure(EventFailure(EventFailureType.updateFailed));
    }
  }

  @override
  Future<Result<void, EventFailure>> leaveEvent({
    required String eventId,
    required String userId,
  }) async {
    try {
      await _remoteDataSource.leaveEvent(eventId: eventId, userId: userId);
      return const Success(null);
    } catch (_) {
      return const Failure(EventFailure(EventFailureType.updateFailed));
    }
  }

  @override
  Future<Result<void, EventFailure>> removeParticipant({
    required String eventId,
    required String userId,
  }) async {
    try {
      await _remoteDataSource.removeParticipant(
        eventId: eventId,
        userId: userId,
      );
      return const Success(null);
    } catch (_) {
      return const Failure(EventFailure(EventFailureType.updateFailed));
    }
  }
}
