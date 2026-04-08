import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_question/features/events/data/constants/events_constants.dart';
import 'package:go_question/features/events/data/models/event_model.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/domain/errors/event_exceptions.dart';

abstract interface class IEventsRemoteDataSource {
  Future<List<EventEntity>> getEvents();
  Future<EventEntity> getEventById(String id);
  Future<void> createEvent(EventEntity event);
  Future<void> updateEvent(EventEntity event);
  Future<void> deleteEvent(String id);
}

class EventsRemoteDataSourceImpl implements IEventsRemoteDataSource {
  final FirebaseFirestore _firestore;

  const EventsRemoteDataSourceImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _eventsRef =>
      _firestore.collection(EventsConstants.eventsCollection);

  @override
  Future<List<EventEntity>> getEvents() async {
    try {
      final snapshot = await _eventsRef.get();
      return snapshot.docs
          .map((doc) => EventModelX.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (_) {
      throw const EventFetchException();
    } catch (_) {
      throw const EventFetchException();
    }
  }

  @override
  Future<EventEntity> getEventById(String id) async {
    try {
      final doc = await _eventsRef.doc(id).get();
      if (!doc.exists) {
        throw const EventNotFoundException();
      }
      return EventModelX.fromFirestore(doc);
    } on EventNotFoundException {
      rethrow;
    } on FirebaseException catch (_) {
      throw const EventFetchException();
    } catch (_) {
      throw const EventFetchException();
    }
  }

  @override
  Future<void> createEvent(EventEntity event) async {
    try {
      final data = event.toFirestore();
      await _eventsRef.doc(event.id).set(data);
    } on FirebaseException catch (_) {
      throw const EventCreationException();
    } catch (_) {
      throw const EventCreationException();
    }
  }

  @override
  Future<void> updateEvent(EventEntity event) async {
    try {
      final doc = await _eventsRef.doc(event.id).get();
      if (!doc.exists) {
        throw const EventNotFoundException();
      }
      final data = event.toFirestore();
      await _eventsRef.doc(event.id).update(data);
    } on EventNotFoundException {
      rethrow;
    } on FirebaseException catch (_) {
      throw const EventUpdateException();
    } catch (_) {
      throw const EventUpdateException();
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    try {
      final doc = await _eventsRef.doc(id).get();
      if (!doc.exists) {
        throw const EventNotFoundException();
      }
      await _eventsRef.doc(id).delete();
    } on EventNotFoundException {
      rethrow;
    } on FirebaseException catch (_) {
      throw const EventDeletionException();
    } catch (_) {
      throw const EventDeletionException();
    }
  }
}
