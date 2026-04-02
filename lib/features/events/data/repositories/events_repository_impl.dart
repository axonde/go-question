import 'package:go_question/features/events/domain/event_entity.dart';
import 'package:go_question/features/events/domain/repositories/i_events_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/event_model.dart';

class EventsRepositoryImpl implements IEventsRepository {
  final FirebaseFirestore firestore;
  
  EventsRepositoryImpl(this.firestore);

  @override
  Future<void> createEvent(EventEntity event) async {
    final eventModel = EventModel.fromEntity(event);
    
    await firestore
        .collection('events')
        .doc(eventModel.id)
        .set(eventModel.toMap());
  }

  @override
  Future<void> deleteEvent(String id) {
    // TODO: implement deleteEvent
    throw UnimplementedError();
  }

  @override
  Future<EventEntity> getEventById(String id) {
    // TODO: implement getEventById
    throw UnimplementedError();
  }

  @override
  Future<List<EventEntity>> getEvents() {
    // TODO: implement getEvents
    throw UnimplementedError();
  }

  @override
  Future<void> updateEvent(EventEntity event) {
    // TODO: implement updateEvent
    throw UnimplementedError();
  }
}