import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/domain/errors/event_failures.dart';
import 'package:go_question/features/events/domain/repositories/i_events_repository.dart';
import 'package:go_question/features/events/presentation/bloc/events_bloc.dart';

class FakeEventsRepository implements IEventsRepository {
  Result<List<EventEntity>, EventFailure>? getEventsResult;
  @override
  Future<Result<void, EventFailure>> createEvent(EventEntity event) async =>
      throw UnimplementedError();
  @override
  Future<Result<void, EventFailure>> requestJoinEvent({
    required String eventId,
    required String requesterId,
  }) async => throw UnimplementedError();
  @override
  Future<Result<void, EventFailure>> deleteEvent(String id) async =>
      throw UnimplementedError();
  @override
  Future<Result<void, EventFailure>> approveJoinRequest({
    required String requestId,
    required String organizerId,
  }) async => throw UnimplementedError();
  @override
  Future<Result<void, EventFailure>> rejectJoinRequest({
    required String requestId,
    required String organizerId,
  }) async => throw UnimplementedError();
  @override
  Future<Result<void, EventFailure>> leaveEvent({
    required String eventId,
    required String userId,
  }) async => throw UnimplementedError();
  @override
  Future<Result<void, EventFailure>> removeParticipant({
    required String eventId,
    required String userId,
  }) async => throw UnimplementedError();
  @override
  Future<Result<EventEntity, EventFailure>> getEventById(String id) async =>
      throw UnimplementedError();
  @override
  Future<Result<List<EventEntity>, EventFailure>> getEvents() async =>
      getEventsResult!;
  @override
  Future<Result<void, EventFailure>> updateEvent(EventEntity event) async =>
      throw UnimplementedError();
}

void main() {
  late FakeEventsRepository repository;
  late EventsBloc bloc;

  setUp(() {
    repository = FakeEventsRepository();
    bloc = EventsBloc(repository);
  });

  tearDown(() {
    bloc.close();
  });

  final tEvent = EventEntity(
    id: '1',
    title: 'Test Event',
    description: 'Test Description',
    startTime: DateTime.utc(2023),
    location: 'Location',
    category: 'Category',
    price: 0.0,
    maxUsers: 10,
    participants: 0,
    organizer: 'Organizer',
    status: 'active',
    createdAt: DateTime.utc(2023),
    updatedAt: DateTime.utc(2023),
  );

  test('emits [Loading, Success] when search starts and succeeds', () async {
    repository.getEventsResult = Success([tEvent]);

    final states = <EventsState>[];
    final subscription = bloc.stream.listen(states.add);

    bloc.add(const EventsSearchStarted());
    await Future.delayed(Duration.zero);

    expect(states, [
      const EventsState(status: EventsStatus.loading),
      EventsState(status: EventsStatus.success, events: [tEvent]),
    ]);

    await subscription.cancel();
  });

  test('emits [Loading, Failure] when search starts and fails', () async {
    repository.getEventsResult = const Failure(
      EventFailure(EventFailureType.fetchFailed, message: 'Network error'),
    );

    final states = <EventsState>[];
    final subscription = bloc.stream.listen(states.add);

    bloc.add(const EventsSearchStarted());
    await Future.delayed(Duration.zero);

    expect(states, [
      const EventsState(status: EventsStatus.loading),
      const EventsState(
        status: EventsStatus.failure,
        errorMessage: 'Network error',
      ),
    ]);

    await subscription.cancel();
  });
}
