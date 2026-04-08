import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/domain/errors/event_failures.dart';
import 'package:go_question/features/events/domain/repositories/i_events_repository.dart';

import '../models/event_model.dart';

class EventsRepositoryImpl implements IEventsRepository {
  final FirebaseFirestore firestore;

  EventsRepositoryImpl(this.firestore);

  @override
  Future<Result<void, EventFailure>> createEvent(EventEntity event) async {
    try {
      final eventModel = EventModel.fromEntity(event);

      await firestore
          .collection('events')
          .doc(eventModel.id)
          .set(eventModel.toMap());

      return const Success(null);
    } catch (e) {
      return const Failure(EventFailure(EventFailureType.creationFailed));
    }
  }

  @override
  Future<Result<void, EventFailure>> deleteEvent(String id) async {
    // TODO: implement deleteEvent
    throw UnimplementedError();
  }

  @override
  Future<Result<EventEntity, EventFailure>> getEventById(String id) async {
    // TODO: implement getEventById
    throw UnimplementedError();
  }

  @override
  Future<Result<List<EventEntity>, EventFailure>> getEvents() async {
    // TODO: implement getEvents
    throw UnimplementedError();
  }

  @override
  Future<Result<void, EventFailure>> updateEvent(EventEntity event) async {
    // TODO: implement updateEvent
    throw UnimplementedError();
  }
}
