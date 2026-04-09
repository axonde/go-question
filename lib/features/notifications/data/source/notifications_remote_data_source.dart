import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_question/features/notifications/data/constants/notifications_constants.dart';
import 'package:go_question/features/notifications/data/models/notification_model.dart';
import 'package:go_question/features/notifications/domain/entities/notification_entity.dart';
import 'package:go_question/features/notifications/domain/errors/notification_exceptions.dart';

abstract interface class INotificationsRemoteDataSource {
  Future<List<NotificationEntity>> getNotifications(String userId);
  Stream<List<NotificationEntity>> watchNotifications(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
}

class NotificationsRemoteDataSourceImpl
    implements INotificationsRemoteDataSource {
  final FirebaseFirestore _firestore;

  const NotificationsRemoteDataSourceImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _notificationsRef =>
      _firestore.collection(NotificationsConstants.notificationsCollection);

  @override
  Future<List<NotificationEntity>> getNotifications(String userId) async {
    try {
      final snapshot = await _notificationsRef
          .where(NotificationsConstants.fieldUserId, isEqualTo: userId)
          .orderBy(NotificationsConstants.fieldCreatedAt, descending: true)
          .get();
      return snapshot.docs
          .map((doc) => NotificationModelX.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (_) {
      throw const NotificationFetchException();
    } catch (_) {
      throw const NotificationFetchException();
    }
  }

  @override
  Stream<List<NotificationEntity>> watchNotifications(String userId) {
    return _notificationsRef
        .where(NotificationsConstants.fieldUserId, isEqualTo: userId)
        .orderBy(NotificationsConstants.fieldCreatedAt, descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModelX.fromFirestore(doc))
              .toList(growable: false),
        );
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      final doc = await _notificationsRef.doc(notificationId).get();
      if (!doc.exists) {
        throw const NotificationNotFoundException();
      }
      await _notificationsRef.doc(notificationId).update({
        NotificationsConstants.fieldIsRead: true,
      });
    } on NotificationNotFoundException {
      rethrow;
    } on FirebaseException catch (_) {
      throw const NotificationUpdateException();
    } catch (_) {
      throw const NotificationUpdateException();
    }
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    try {
      final snapshot = await _notificationsRef
          .where(NotificationsConstants.fieldUserId, isEqualTo: userId)
          .where(NotificationsConstants.fieldIsRead, isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {NotificationsConstants.fieldIsRead: true});
      }
      await batch.commit();
    } on FirebaseException catch (_) {
      throw const NotificationUpdateException();
    } catch (_) {
      throw const NotificationUpdateException();
    }
  }
}
