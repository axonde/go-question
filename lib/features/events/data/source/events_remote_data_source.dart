import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_question/core/constants/achievement_constants.dart';
import 'package:go_question/features/events/data/constants/events_constants.dart';
import 'package:go_question/features/events/data/models/event_model.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/domain/errors/event_exceptions.dart';
import 'package:go_question/features/notifications/data/constants/notifications_constants.dart';
import 'package:go_question/features/profile/constants/profile_firestore.dart';

abstract interface class IEventsRemoteDataSource {
  Future<List<EventEntity>> getEvents();
  Stream<List<EventEntity>> watchEvents();
  Future<EventEntity> getEventById(String id);
  Future<void> createEvent(EventEntity event);
  Future<void> updateEvent(EventEntity event);
  Future<void> deleteEvent(String id);
  Future<void> requestJoinEvent({
    required String eventId,
    required String requesterId,
  });
  Future<void> approveJoinRequest({
    required String requestId,
    required String organizerId,
  });
  Future<void> rejectJoinRequest({
    required String requestId,
    required String organizerId,
  });
  Future<void> leaveEvent({required String eventId, required String userId});
  Future<void> removeParticipant({
    required String eventId,
    required String userId,
  });
}

class EventsRemoteDataSourceImpl implements IEventsRemoteDataSource {
  final FirebaseFirestore _firestore;
  DateTime? _lastExpiredProcessingAt;

  EventsRemoteDataSourceImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _eventsRef =>
      _firestore.collection(EventsConstants.eventsCollection);

  CollectionReference<Map<String, dynamic>> get _joinRequestsRef =>
      _firestore.collection(EventsConstants.eventJoinRequestsCollection);

  CollectionReference<Map<String, dynamic>> get _notificationsRef =>
      _firestore.collection(NotificationsConstants.notificationsCollection);

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection(ProfileFirestoreConstants.usersCollection);

  @override
  Future<List<EventEntity>> getEvents() async {
    try {
      await _processExpiredEventsIfNeeded();
      final snapshot = await _eventsRef
          .orderBy(EventsConstants.fieldStartTime)
          .get();
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
  Stream<List<EventEntity>> watchEvents() {
    return _eventsRef
        .orderBy(EventsConstants.fieldStartTime)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => EventModelX.fromFirestore(doc))
              .toList(growable: false),
        );
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
      await _usersRef.doc(event.organizer).update({
        ProfileFirestoreConstants.fieldCreatedEventIds: FieldValue.arrayUnion([
          event.id,
        ]),
        ProfileFirestoreConstants.fieldCreatedEventsCount: FieldValue.increment(
          1,
        ),
        ProfileFirestoreConstants.fieldAchievementIds: FieldValue.arrayUnion([
          AchievementConstants.firstCreatedEvent,
        ]),
        ProfileFirestoreConstants.fieldUnseenAchievementIds:
            FieldValue.arrayUnion([AchievementConstants.firstCreatedEvent]),
        ProfileFirestoreConstants.fieldUpdatedAt: FieldValue.serverTimestamp(),
      });
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
      final existingOrganizer =
          (doc.data() ?? <String, dynamic>{})[EventsConstants.fieldOrganizer]
              as String?;
      if (existingOrganizer != null && existingOrganizer != event.organizer) {
        throw const EventUpdateException();
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
      final docRef = _eventsRef.doc(id);
      final doc = await docRef.get();
      if (!doc.exists) {
        throw const EventNotFoundException();
      }

      final data = doc.data() ?? <String, dynamic>{};
      final organizerId = data[EventsConstants.fieldOrganizer] as String?;
      final participantIds = List<String>.from(
        data[EventsConstants.fieldParticipantIds] ?? const <String>[],
      );
      final startTime = _toDateTime(data[EventsConstants.fieldStartTime]);
      final durationMinutes =
          (data[EventsConstants.fieldDurationMinutes] as num?)?.toInt() ??
          EventsConstants.defaultDurationMinutes;
      final hasParticipants = participantIds.isNotEmpty;
      final isCancelledEarly =
          startTime != null &&
          DateTime.now().isBefore(
            startTime.add(Duration(minutes: durationMinutes)),
          );
      int? organizerPenaltyTrophies;

      await _firestore.runTransaction((tx) async {
        if (organizerId != null &&
            organizerId.isNotEmpty &&
            hasParticipants &&
            isCancelledEarly) {
          final organizerRef = _usersRef.doc(organizerId);
          final organizerSnapshot = await tx.get(organizerRef);
          if (organizerSnapshot.exists) {
            final organizerData =
                organizerSnapshot.data() ?? <String, dynamic>{};
            final currentTrophies =
                (organizerData[ProfileFirestoreConstants.fieldTrophies] as num?)
                    ?.toInt() ??
                0;
            organizerPenaltyTrophies = max(0, currentTrophies - 10);
          }
        }

        tx.delete(docRef);

        if (organizerId != null && organizerId.isNotEmpty) {
          final organizerUpdates = <String, dynamic>{
            ProfileFirestoreConstants.fieldCreatedEventIds:
                FieldValue.arrayRemove([id]),
            ProfileFirestoreConstants.fieldCreatedEventsCount:
                FieldValue.increment(-1),
            ProfileFirestoreConstants.fieldUpdatedAt:
                FieldValue.serverTimestamp(),
          };
          if (organizerPenaltyTrophies != null) {
            organizerUpdates[ProfileFirestoreConstants.fieldTrophies] =
                organizerPenaltyTrophies;
          }
          tx.update(_usersRef.doc(organizerId), organizerUpdates);
        }
        for (final participantId in participantIds) {
          if (participantId.trim().isEmpty) {
            continue;
          }
          tx.update(_usersRef.doc(participantId), {
            ProfileFirestoreConstants.fieldJoinedEventIds:
                FieldValue.arrayRemove([id]),
            ProfileFirestoreConstants.fieldUpdatedAt:
                FieldValue.serverTimestamp(),
          });
        }
      });
    } on EventNotFoundException {
      rethrow;
    } on FirebaseException catch (_) {
      throw const EventDeletionException();
    } catch (_) {
      throw const EventDeletionException();
    }
  }

  Future<void> _processExpiredEventsIfNeeded() async {
    final now = DateTime.now();
    final lastRun = _lastExpiredProcessingAt;
    if (lastRun != null && now.difference(lastRun).inSeconds < 30) {
      return;
    }
    _lastExpiredProcessingAt = now;

    final snapshot = await _eventsRef.get();
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final startTime = _toDateTime(data[EventsConstants.fieldStartTime]);
      if (startTime == null) {
        continue;
      }
      final durationMinutes =
          (data[EventsConstants.fieldDurationMinutes] as num?)?.toInt() ??
          EventsConstants.defaultDurationMinutes;
      final endedAt = startTime.add(Duration(minutes: durationMinutes));
      if (now.isBefore(endedAt)) {
        continue;
      }
      await _completeAndDeleteExpiredEvent(doc.id);
    }
  }

  Future<void> _completeAndDeleteExpiredEvent(String eventId) async {
    final eventRef = _eventsRef.doc(eventId);
    await _firestore.runTransaction((tx) async {
      final eventSnapshot = await tx.get(eventRef);
      if (!eventSnapshot.exists) {
        return;
      }

      final data = eventSnapshot.data() ?? <String, dynamic>{};
      final status = data[EventsConstants.fieldStatus] as String?;
      final organizerId = data[EventsConstants.fieldOrganizer] as String?;
      if (organizerId == null || organizerId.trim().isEmpty) {
        tx.delete(eventRef);
        return;
      }

      final participantIds = List<String>.from(
        data[EventsConstants.fieldParticipantIds] ?? const <String>[],
      ).where((id) => id.trim().isNotEmpty).toSet().toList();
      final hasParticipants = participantIds.isNotEmpty;
      final shouldReward =
          hasParticipants && status != EventsConstants.statusCancelled;

      final participantRewardTrophies = <String, int>{};
      int? organizerRewardTrophies;

      if (shouldReward) {
        for (final participantId in participantIds) {
          final userRef = _usersRef.doc(participantId);
          final userSnapshot = await tx.get(userRef);
          if (!userSnapshot.exists) {
            continue;
          }
          final reward = _deterministicReward(
            seed: '${eventId}_$participantId',
            min: 20,
            max: 40,
          );
          final userData = userSnapshot.data() ?? <String, dynamic>{};
          final currentTrophies =
              (userData[ProfileFirestoreConstants.fieldTrophies] as num?)
                  ?.toInt() ??
              0;
          participantRewardTrophies[participantId] = max(
            0,
            currentTrophies + reward,
          );
        }

        final organizerRef = _usersRef.doc(organizerId);
        final organizerSnapshot = await tx.get(organizerRef);
        if (organizerSnapshot.exists) {
          final organizerReward = _deterministicReward(
            seed: '${eventId}_organizer_$organizerId',
            min: 30,
            max: 50,
          );
          final organizerData = organizerSnapshot.data() ?? <String, dynamic>{};
          final currentTrophies =
              (organizerData[ProfileFirestoreConstants.fieldTrophies] as num?)
                  ?.toInt() ??
              0;
          organizerRewardTrophies = max(0, currentTrophies + organizerReward);
        }
      }

      tx.delete(eventRef);
      final organizerUpdates = <String, dynamic>{
        ProfileFirestoreConstants.fieldCreatedEventIds: FieldValue.arrayRemove([
          eventId,
        ]),
        ProfileFirestoreConstants.fieldCreatedEventsCount: FieldValue.increment(
          -1,
        ),
        ProfileFirestoreConstants.fieldUpdatedAt: FieldValue.serverTimestamp(),
      };
      if (organizerRewardTrophies != null) {
        organizerUpdates[ProfileFirestoreConstants.fieldTrophies] =
            organizerRewardTrophies;
      }
      tx.update(_usersRef.doc(organizerId), organizerUpdates);

      for (final participantId in participantIds) {
        final participantUpdates = <String, dynamic>{
          ProfileFirestoreConstants.fieldJoinedEventIds: FieldValue.arrayRemove(
            [eventId],
          ),
          ProfileFirestoreConstants.fieldUpdatedAt:
              FieldValue.serverTimestamp(),
        };
        final nextTrophies = participantRewardTrophies[participantId];
        if (nextTrophies != null) {
          participantUpdates[ProfileFirestoreConstants.fieldTrophies] =
              nextTrophies;
        }
        tx.update(_usersRef.doc(participantId), participantUpdates);
      }
    });
  }

  int _deterministicReward({
    required String seed,
    required int min,
    required int max,
  }) {
    final spread = max - min + 1;
    final hash = seed.codeUnits.fold<int>(0, (acc, unit) => acc * 31 + unit);
    return min + Random(hash).nextInt(spread);
  }

  DateTime? _toDateTime(Object? rawValue) {
    if (rawValue is Timestamp) {
      return rawValue.toDate();
    }
    if (rawValue is DateTime) {
      return rawValue;
    }
    return null;
  }

  @override
  Future<void> requestJoinEvent({
    required String eventId,
    required String requesterId,
  }) async {
    try {
      final eventRef = _eventsRef.doc(eventId);
      final requestId = '${requesterId}_$eventId';
      final requestRef = _joinRequestsRef.doc(requestId);
      final requesterRef = _usersRef.doc(requesterId);

      await _firestore.runTransaction((tx) async {
        final eventSnapshot = await tx.get(eventRef);
        final requesterSnapshot = await tx.get(requesterRef);
        if (!eventSnapshot.exists || !requesterSnapshot.exists) {
          throw const EventNotFoundException();
        }

        final eventData = eventSnapshot.data() ?? <String, dynamic>{};
        final requesterData = requesterSnapshot.data() ?? <String, dynamic>{};
        final pending = List<String>.from(
          eventData[EventsConstants.fieldPendingParticipantIds] ??
              const <String>[],
        );
        final participants = List<String>.from(
          eventData[EventsConstants.fieldParticipantIds] ?? const <String>[],
        );
        final maxUsers =
            (eventData[EventsConstants.fieldMaxUsers] as num?)?.toInt() ?? 0;
        if (participants.contains(requesterId) ||
            pending.contains(requesterId)) {
          return;
        }
        if (maxUsers > 0 && participants.length >= maxUsers) {
          return;
        }

        tx.set(requestRef, {
          EventsConstants.joinRequestFieldId: requestId,
          EventsConstants.joinRequestFieldEventId: eventId,
          EventsConstants.joinRequestFieldRequesterId: requesterId,
          EventsConstants.joinRequestFieldOrganizerId:
              eventData[EventsConstants.fieldOrganizer],
          EventsConstants.joinRequestFieldStatus:
              EventsConstants.joinRequestStatusPending,
          EventsConstants.joinRequestFieldCreatedAt:
              FieldValue.serverTimestamp(),
          EventsConstants.joinRequestFieldUpdatedAt:
              FieldValue.serverTimestamp(),
          EventsConstants.joinRequestFieldReviewedAt: null,
          EventsConstants.joinRequestFieldReviewedBy: null,
        }, SetOptions(merge: true));

        tx.update(eventRef, {
          EventsConstants.fieldPendingParticipantIds: FieldValue.arrayUnion([
            requesterId,
          ]),
          EventsConstants.fieldUpdatedAt: FieldValue.serverTimestamp(),
        });

        tx.update(requesterRef, {
          ProfileFirestoreConstants.fieldUpdatedAt:
              FieldValue.serverTimestamp(),
        });

        tx.set(_notificationsRef.doc(requestId), {
          NotificationsConstants.fieldId: requestId,
          NotificationsConstants.fieldUserId:
              eventData[EventsConstants.fieldOrganizer],
          NotificationsConstants.fieldTitle: 'Новая заявка на участие',
          NotificationsConstants.fieldBody:
              'Пользователь ${requesterData[ProfileFirestoreConstants.fieldName] ?? requesterId}'
              ' (ID: ${requesterData[ProfileFirestoreConstants.fieldRegistrationId] ?? requesterId})'
              ' хочет присоединиться к событию ${eventData[EventsConstants.fieldTitle]}',
          NotificationsConstants.fieldType: 'join_request',
          NotificationsConstants.fieldIsRead: false,
          NotificationsConstants.fieldCreatedAt: FieldValue.serverTimestamp(),
          NotificationsConstants.fieldRequestUserId: requesterId,
          NotificationsConstants.fieldRequestUserName:
              requesterData[ProfileFirestoreConstants.fieldName],
          NotificationsConstants.fieldRequestUserAvatarUrl:
              requesterData[ProfileFirestoreConstants.fieldAvatarUrl],
          NotificationsConstants.fieldRequestUserRegistrationId:
              requesterData[ProfileFirestoreConstants.fieldRegistrationId]
                  ?.toString(),
          NotificationsConstants.fieldRequestUserRating:
              requesterData[ProfileFirestoreConstants.fieldRating]?.toString(),
          NotificationsConstants.fieldRequestUserAge:
              requesterData[ProfileFirestoreConstants.fieldAge]?.toString(),
          NotificationsConstants.fieldRequestUserGender:
              requesterData[ProfileFirestoreConstants.fieldGender],
          NotificationsConstants.fieldRequestUserCity:
              requesterData[ProfileFirestoreConstants.fieldCity],
          NotificationsConstants.fieldRequestUserBio:
              requesterData[ProfileFirestoreConstants.fieldBio],
          NotificationsConstants.fieldRequestUserEventsAttended:
              requesterData[ProfileFirestoreConstants.fieldVisitedEventsCount],
          NotificationsConstants.fieldRequestUserEventsOrganized:
              requesterData[ProfileFirestoreConstants.fieldCreatedEventsCount],
          NotificationsConstants.fieldEventId: eventId,
          NotificationsConstants.fieldEventTitle:
              eventData[EventsConstants.fieldTitle],
          NotificationsConstants.fieldEventLocation:
              eventData[EventsConstants.fieldLocation],
          NotificationsConstants.fieldEventCategory:
              eventData[EventsConstants.fieldCategory],
        }, SetOptions(merge: true));
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> approveJoinRequest({
    required String requestId,
    required String organizerId,
  }) async {
    try {
      final requestRef = _joinRequestsRef.doc(requestId);

      await _firestore.runTransaction((tx) async {
        final requestSnapshot = await tx.get(requestRef);
        if (!requestSnapshot.exists) {
          throw const EventNotFoundException();
        }

        final requestData = requestSnapshot.data() ?? <String, dynamic>{};
        final status =
            requestData[EventsConstants.joinRequestFieldStatus] as String?;
        if (status != EventsConstants.joinRequestStatusPending) {
          return;
        }
        if (requestData[EventsConstants.joinRequestFieldOrganizerId] !=
            organizerId) {
          throw const EventUpdateException();
        }

        final eventId =
            requestData[EventsConstants.joinRequestFieldEventId] as String?;
        final requesterId =
            requestData[EventsConstants.joinRequestFieldRequesterId] as String?;
        if (eventId == null || requesterId == null) {
          throw const EventUpdateException();
        }

        final eventRef = _eventsRef.doc(eventId);
        final requesterRef = _usersRef.doc(requesterId);
        final eventSnapshot = await tx.get(eventRef);
        if (!eventSnapshot.exists) {
          throw const EventNotFoundException();
        }
        final eventData = eventSnapshot.data() ?? <String, dynamic>{};
        final participants = List<String>.from(
          eventData[EventsConstants.fieldParticipantIds] ?? const <String>[],
        );
        final maxUsers =
            (eventData[EventsConstants.fieldMaxUsers] as num?)?.toInt() ?? 0;
        if (participants.contains(requesterId)) {
          tx.update(requestRef, {
            EventsConstants.joinRequestFieldStatus:
                EventsConstants.joinRequestStatusApproved,
            EventsConstants.joinRequestFieldReviewedAt:
                FieldValue.serverTimestamp(),
            EventsConstants.joinRequestFieldReviewedBy: organizerId,
            EventsConstants.joinRequestFieldUpdatedAt:
                FieldValue.serverTimestamp(),
          });
          return;
        }
        if (maxUsers > 0 && participants.length >= maxUsers) {
          tx.update(eventRef, {
            EventsConstants.fieldPendingParticipantIds: FieldValue.arrayRemove([
              requesterId,
            ]),
            EventsConstants.fieldRejectedParticipantIds: FieldValue.arrayUnion([
              requesterId,
            ]),
            EventsConstants.fieldUpdatedAt: FieldValue.serverTimestamp(),
          });
          tx.update(requestRef, {
            EventsConstants.joinRequestFieldStatus:
                EventsConstants.joinRequestStatusRejected,
            EventsConstants.joinRequestFieldReviewedAt:
                FieldValue.serverTimestamp(),
            EventsConstants.joinRequestFieldReviewedBy: organizerId,
            EventsConstants.joinRequestFieldUpdatedAt:
                FieldValue.serverTimestamp(),
          });
          tx.set(_notificationsRef.doc('${requestId}_full'), {
            NotificationsConstants.fieldId: '${requestId}_full',
            NotificationsConstants.fieldUserId: requesterId,
            NotificationsConstants.fieldTitle: 'Мест больше нет',
            NotificationsConstants.fieldBody:
                'Свободные места на событие ${eventData[EventsConstants.fieldTitle]} закончились',
            NotificationsConstants.fieldType: 'system',
            NotificationsConstants.fieldIsRead: false,
            NotificationsConstants.fieldCreatedAt: FieldValue.serverTimestamp(),
            NotificationsConstants.fieldEventId: eventId,
            NotificationsConstants.fieldEventTitle:
                eventData[EventsConstants.fieldTitle],
            NotificationsConstants.fieldEventLocation:
                eventData[EventsConstants.fieldLocation],
            NotificationsConstants.fieldEventCategory:
                eventData[EventsConstants.fieldCategory],
          }, SetOptions(merge: true));
          return;
        }

        tx.update(eventRef, {
          EventsConstants.fieldParticipantIds: FieldValue.arrayUnion([
            requesterId,
          ]),
          EventsConstants.fieldPendingParticipantIds: FieldValue.arrayRemove([
            requesterId,
          ]),
          EventsConstants.fieldParticipants: FieldValue.increment(1),
          EventsConstants.fieldUpdatedAt: FieldValue.serverTimestamp(),
        });
        tx.update(requesterRef, {
          ProfileFirestoreConstants.fieldJoinedEventIds: FieldValue.arrayUnion([
            eventId,
          ]),
          ProfileFirestoreConstants.fieldVisitedEventsCount:
              FieldValue.increment(1),
          ProfileFirestoreConstants.fieldAchievementIds: FieldValue.arrayUnion([
            AchievementConstants.firstJoinedEvent,
          ]),
          ProfileFirestoreConstants.fieldUnseenAchievementIds:
              FieldValue.arrayUnion([AchievementConstants.firstJoinedEvent]),
          ProfileFirestoreConstants.fieldUpdatedAt:
              FieldValue.serverTimestamp(),
        });
        tx.update(requestRef, {
          EventsConstants.joinRequestFieldStatus:
              EventsConstants.joinRequestStatusApproved,
          EventsConstants.joinRequestFieldReviewedAt:
              FieldValue.serverTimestamp(),
          EventsConstants.joinRequestFieldReviewedBy: organizerId,
          EventsConstants.joinRequestFieldUpdatedAt:
              FieldValue.serverTimestamp(),
        });

        tx.set(_notificationsRef.doc('${requestId}_approved'), {
          NotificationsConstants.fieldId: '${requestId}_approved',
          NotificationsConstants.fieldUserId: requesterId,
          NotificationsConstants.fieldTitle: 'Заявка одобрена',
          NotificationsConstants.fieldBody:
              'Ваше участие в событии ${eventData[EventsConstants.fieldTitle]} подтверждено',
          NotificationsConstants.fieldType: 'system',
          NotificationsConstants.fieldIsRead: false,
          NotificationsConstants.fieldCreatedAt: FieldValue.serverTimestamp(),
          NotificationsConstants.fieldEventId: eventId,
          NotificationsConstants.fieldEventTitle:
              eventData[EventsConstants.fieldTitle],
          NotificationsConstants.fieldEventLocation:
              eventData[EventsConstants.fieldLocation],
          NotificationsConstants.fieldEventCategory:
              eventData[EventsConstants.fieldCategory],
        }, SetOptions(merge: true));
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> rejectJoinRequest({
    required String requestId,
    required String organizerId,
  }) async {
    try {
      final requestRef = _joinRequestsRef.doc(requestId);

      await _firestore.runTransaction((tx) async {
        final requestSnapshot = await tx.get(requestRef);
        if (!requestSnapshot.exists) {
          throw const EventNotFoundException();
        }

        final requestData = requestSnapshot.data() ?? <String, dynamic>{};
        final status =
            requestData[EventsConstants.joinRequestFieldStatus] as String?;
        if (status != EventsConstants.joinRequestStatusPending) {
          return;
        }
        if (requestData[EventsConstants.joinRequestFieldOrganizerId] !=
            organizerId) {
          throw const EventUpdateException();
        }

        final eventId =
            requestData[EventsConstants.joinRequestFieldEventId] as String?;
        final requesterId =
            requestData[EventsConstants.joinRequestFieldRequesterId] as String?;
        if (eventId == null || requesterId == null) {
          throw const EventUpdateException();
        }

        final eventRef = _eventsRef.doc(eventId);
        final requesterRef = _usersRef.doc(requesterId);
        final eventSnapshot = await tx.get(eventRef);
        final eventData = eventSnapshot.data() ?? <String, dynamic>{};
        final pendingParticipants = List<String>.from(
          eventData[EventsConstants.fieldPendingParticipantIds] ??
              const <String>[],
        );

        if (!pendingParticipants.contains(requesterId)) {
          tx.update(requestRef, {
            EventsConstants.joinRequestFieldStatus:
                EventsConstants.joinRequestStatusRejected,
            EventsConstants.joinRequestFieldReviewedAt:
                FieldValue.serverTimestamp(),
            EventsConstants.joinRequestFieldReviewedBy: organizerId,
            EventsConstants.joinRequestFieldUpdatedAt:
                FieldValue.serverTimestamp(),
          });
          return;
        }

        tx.update(eventRef, {
          EventsConstants.fieldPendingParticipantIds: FieldValue.arrayRemove([
            requesterId,
          ]),
          EventsConstants.fieldRejectedParticipantIds: FieldValue.arrayUnion([
            requesterId,
          ]),
          EventsConstants.fieldUpdatedAt: FieldValue.serverTimestamp(),
        });
        tx.update(requesterRef, {
          ProfileFirestoreConstants.fieldUpdatedAt:
              FieldValue.serverTimestamp(),
        });
        tx.update(requestRef, {
          EventsConstants.joinRequestFieldStatus:
              EventsConstants.joinRequestStatusRejected,
          EventsConstants.joinRequestFieldReviewedAt:
              FieldValue.serverTimestamp(),
          EventsConstants.joinRequestFieldReviewedBy: organizerId,
          EventsConstants.joinRequestFieldUpdatedAt:
              FieldValue.serverTimestamp(),
        });

        tx.set(_notificationsRef.doc('${requestId}_rejected'), {
          NotificationsConstants.fieldId: '${requestId}_rejected',
          NotificationsConstants.fieldUserId: requesterId,
          NotificationsConstants.fieldTitle: 'Заявка отклонена',
          NotificationsConstants.fieldBody:
              'Организатор отклонил вашу заявку на событие ${eventData[EventsConstants.fieldTitle]}',
          NotificationsConstants.fieldType: 'system',
          NotificationsConstants.fieldIsRead: false,
          NotificationsConstants.fieldCreatedAt: FieldValue.serverTimestamp(),
          NotificationsConstants.fieldEventId: eventId,
          NotificationsConstants.fieldEventTitle:
              eventData[EventsConstants.fieldTitle],
          NotificationsConstants.fieldEventLocation:
              eventData[EventsConstants.fieldLocation],
          NotificationsConstants.fieldEventCategory:
              eventData[EventsConstants.fieldCategory],
        }, SetOptions(merge: true));
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> leaveEvent({
    required String eventId,
    required String userId,
  }) async {
    try {
      final eventRef = _eventsRef.doc(eventId);
      final userRef = _usersRef.doc(userId);

      await _firestore.runTransaction((tx) async {
        final eventSnapshot = await tx.get(eventRef);
        if (!eventSnapshot.exists) {
          throw const EventNotFoundException();
        }
        final eventData = eventSnapshot.data() ?? <String, dynamic>{};
        final participants = List<String>.from(
          eventData[EventsConstants.fieldParticipantIds] ?? const <String>[],
        );
        if (!participants.contains(userId)) {
          return;
        }

        tx.update(eventRef, {
          EventsConstants.fieldParticipantIds: FieldValue.arrayRemove([userId]),
          EventsConstants.fieldParticipants: FieldValue.increment(-1),
          EventsConstants.fieldUpdatedAt: FieldValue.serverTimestamp(),
        });
        tx.update(userRef, {
          ProfileFirestoreConstants.fieldJoinedEventIds: FieldValue.arrayRemove(
            [eventId],
          ),
          ProfileFirestoreConstants.fieldUpdatedAt:
              FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeParticipant({
    required String eventId,
    required String userId,
  }) async {
    await leaveEvent(eventId: eventId, userId: userId);
  }
}
