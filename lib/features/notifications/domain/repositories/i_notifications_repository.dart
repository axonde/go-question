import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/notifications/domain/entities/notification_entity.dart';
import 'package:go_question/features/notifications/domain/errors/notification_failures.dart';

abstract interface class INotificationsRepository {
  Future<Result<List<NotificationEntity>, NotificationFailure>>
  getNotifications(String userId);
  Future<Result<void, NotificationFailure>> markAsRead(String notificationId);
  Future<Result<void, NotificationFailure>> markAllAsRead(String userId);
}
