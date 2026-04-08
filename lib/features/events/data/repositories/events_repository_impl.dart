import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/events/data/source/events_remote_data_source.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/domain/errors/event_exceptions.dart';
import 'package:go_question/features/events/domain/errors/event_failures.dart';
import 'package:go_question/features/events/domain/repositories/i_events_repository.dart';

class EventsRepositoryImpl implements IEventsRepository {
  final IEventsRemoteDataSource _remoteDataSource;

  const EventsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<EventEntity>, EventFailure>> getEvents() async {
    try {
      final events = await _remoteDataSource.getEvents();
      return Success(events);
    } on EventFetchException {
      return const Failure(EventFailure(EventFailureType.fetchFailed));
    } catch (_) {
      return const Failure(EventFailure(EventFailureType.fetchFailed));
    }
  }

  @override
  Future<Result<EventEntity, EventFailure>> getEventById(String id) async {
    try {
      final event = await _remoteDataSource.getEventById(id);
      return Success(event);
    } on EventNotFoundException {
      return const Failure(EventFailure(EventFailureType.notFound));
    } on EventFetchException {
      return const Failure(EventFailure(EventFailureType.fetchFailed));
    } catch (_) {
      return const Failure(EventFailure(EventFailureType.fetchFailed));
    }
  }

  @override
  Future<Result<void, EventFailure>> createEvent(EventEntity event) async {
    try {
      await _remoteDataSource.createEvent(event);
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
      return const Success(null);
    } on EventNotFoundException {
      return const Failure(EventFailure(EventFailureType.notFound));
    } on EventDeletionException {
      return const Failure(EventFailure(EventFailureType.deletionFailed));
    } catch (_) {
      return const Failure(EventFailure(EventFailureType.deletionFailed));
    }
  }
}
