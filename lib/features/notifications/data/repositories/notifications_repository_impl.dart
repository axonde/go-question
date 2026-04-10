import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/notifications/data/source/notifications_remote_data_source.dart';
import 'package:go_question/features/notifications/domain/entities/notification_entity.dart';
import 'package:go_question/features/notifications/domain/errors/notification_exceptions.dart';
import 'package:go_question/features/notifications/domain/errors/notification_failures.dart';
import 'package:go_question/features/notifications/domain/repositories/i_notifications_repository.dart';

class NotificationsRepositoryImpl implements INotificationsRepository {
  final INotificationsRemoteDataSource _remoteDataSource;

  const NotificationsRepositoryImpl(this._remoteDataSource);

  @override
  Stream<List<NotificationEntity>> watchNotifications(String userId) {
    return _remoteDataSource.watchNotifications(userId);
  }

  @override
  Future<Result<List<NotificationEntity>, NotificationFailure>>
  getNotifications(String userId) async {
    try {
      final notifications = await _remoteDataSource.getNotifications(userId);
      return Success(notifications);
    } on NotificationFetchException {
      return const Failure(
        NotificationFailure(NotificationFailureType.fetchFailed),
      );
    } catch (_) {
      return const Failure(
        NotificationFailure(NotificationFailureType.fetchFailed),
      );
    }
  }

  @override
  Future<Result<void, NotificationFailure>> markAsRead(
    String notificationId,
  ) async {
    try {
      await _remoteDataSource.markAsRead(notificationId);
      return const Success(null);
    } on NotificationNotFoundException {
      return const Failure(
        NotificationFailure(NotificationFailureType.notFound),
      );
    } on NotificationUpdateException {
      return const Failure(
        NotificationFailure(NotificationFailureType.updateFailed),
      );
    } catch (_) {
      return const Failure(
        NotificationFailure(NotificationFailureType.updateFailed),
      );
    }
  }

  @override
  Future<Result<void, NotificationFailure>> markAllAsRead(String userId) async {
    try {
      await _remoteDataSource.markAllAsRead(userId);
      return const Success(null);
    } on NotificationUpdateException {
      return const Failure(
        NotificationFailure(NotificationFailureType.updateFailed),
      );
    } catch (_) {
      return const Failure(
        NotificationFailure(NotificationFailureType.updateFailed),
      );
    }
  }

  @override
  Future<Result<void, NotificationFailure>> clearAll(String userId) async {
    try {
      await _remoteDataSource.clearAll(userId);
      return const Success(null);
    } on NotificationUpdateException {
      return const Failure(
        NotificationFailure(NotificationFailureType.updateFailed),
      );
    } catch (_) {
      return const Failure(
        NotificationFailure(NotificationFailureType.updateFailed),
      );
    }
  }
}
