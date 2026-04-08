import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/domain/errors/event_failures.dart';
import 'package:go_question/features/events/domain/repositories/i_events_repository.dart';
import 'package:go_question/features/events/presentation/bloc/events_search/events_search_bloc.dart';
import 'package:go_question/features/events/presentation/bloc/events_search/events_search_event.dart';
import 'package:go_question/features/events/presentation/bloc/events_search/events_search_state.dart';

class FakeEventsRepository implements IEventsRepository {
  Result<List<EventEntity>, EventFailure>? getEventsResult;
  @override
  Future<Result<void, EventFailure>> createEvent(EventEntity event) async =>
      throw UnimplementedError();
  @override
  Future<Result<void, EventFailure>> deleteEvent(String id) async =>
      throw UnimplementedError();
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
  late EventsSearchBloc bloc;

  setUp(() {
    repository = FakeEventsRepository();
    bloc = EventsSearchBloc(repository);
  });

  tearDown(() {
    bloc.close();
  });

  final tEvent = EventEntity(
    id: '1',
    title: 'Test Event',
    description: 'Test Description',
    startTime: DateTime(2023, 1, 1),
    location: 'Location',
    category: 'Category',
    price: 0.0,
    maxUsers: 10,
    participants: 0,
    organizer: 'Organizer',
    status: 'active',
    createdAt: DateTime(2023, 1, 1),
    updatedAt: DateTime(2023, 1, 1),
  );

  test('emits [Loading, Success] when getEvents succeeds', () async {
    repository.getEventsResult = Success([tEvent]);

    final states = <EventsSearchState>[];
    final subscription = bloc.stream.listen(states.add);

    bloc.add(const EventsSearchEvent.started());
    await Future.delayed(Duration.zero);

    expect(states, [
      const EventsSearchState.loading(),
      EventsSearchState.success([tEvent]),
    ]);

    await subscription.cancel();
  });

  test('emits [Loading, Failure] when getEvents fails', () async {
    repository.getEventsResult = const Failure(
      EventFailure(EventFailureType.fetchFailed),
    );

    final states = <EventsSearchState>[];
    final subscription = bloc.stream.listen(states.add);

    bloc.add(const EventsSearchEvent.started());
    await Future.delayed(Duration.zero);

    expect(states, [
      const EventsSearchState.loading(),
      const EventsSearchState.failure(
        EventFailure(EventFailureType.fetchFailed),
      ),
    ]);

    await subscription.cancel();
  });
}
