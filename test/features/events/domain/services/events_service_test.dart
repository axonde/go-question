import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/domain/errors/event_failures.dart';
import 'package:go_question/features/events/domain/repositories/i_events_repository.dart';
import 'package:go_question/features/events/domain/services/events_service.dart';
import 'package:mocktail/mocktail.dart';

class MockEventsRepository extends Mock implements IEventsRepository {}

void main() {
  late EventsService service;
  late MockEventsRepository mockRepository;

  final tEvent = EventEntity(
    id: '1',
    title: 'Test Event',
    description: 'Description',
    imageUrl: 'url',
    date: DateTime(2025),
    location: 'Location',
    category: 'Category',
    price: 10.0,
    participants: 100,
    organizer: 'Organizer',
    status: 'active',
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
  );

  setUp(() {
    mockRepository = MockEventsRepository();
    service = EventsService(mockRepository);
  });

  group('EventsService', () {
    test('getEvents returns list of events on success', () async {
      when(
        () => mockRepository.getEvents(),
      ).thenAnswer((_) async => Success([tEvent]));

      final result = await service.getEvents();

      expect(result, isA<Success<List<EventEntity>, EventFailure>>());
      result.fold(
        onSuccess: (events) => expect(events, [tEvent]),
        onFailure: (_) => fail('Should return success'),
      );
      verify(() => mockRepository.getEvents()).called(1);
    });

    test('getEventById returns event on success', () async {
      when(
        () => mockRepository.getEventById('1'),
      ).thenAnswer((_) async => Success(tEvent));

      final result = await service.getEventById('1');

      expect(result, isA<Success<EventEntity, EventFailure>>());
      result.fold(
        onSuccess: (event) => expect(event, tEvent),
        onFailure: (_) => fail('Should return success'),
      );
      verify(() => mockRepository.getEventById('1')).called(1);
    });

    test('createEvent returns void on success', () async {
      when(
        () => mockRepository.createEvent(tEvent),
      ).thenAnswer((_) async => const Success(null));

      final result = await service.createEvent(tEvent);

      expect(result, isA<Success<void, EventFailure>>());
      verify(() => mockRepository.createEvent(tEvent)).called(1);
    });
  });
}
