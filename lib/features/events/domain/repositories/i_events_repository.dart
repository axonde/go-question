import 'package:go_question/features/events/domain/event_entity.dart';

abstract class IEventsRepository {
  Future<List<EventEntity>> getEvents();
  Future<EventEntity> getEventById(String id);
  Future<void> createEvent(EventEntity event);
  Future<void> updateEvent(EventEntity event);
  Future<void> deleteEvent(String id);
}
