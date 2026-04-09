part of 'notifications_bloc.dart';

sealed class NotificationsEvent {
  const NotificationsEvent();
}

final class NotificationsStarted extends NotificationsEvent {
  final String userId;

  const NotificationsStarted(this.userId);
}

final class _NotificationsStreamUpdated extends NotificationsEvent {
  final List<NotificationEntity> notifications;

  const _NotificationsStreamUpdated(this.notifications);
}

final class NotificationsMarkAsReadRequested extends NotificationsEvent {
  final String notificationId;

  const NotificationsMarkAsReadRequested(this.notificationId);
}

final class NotificationsMarkAllAsReadRequested extends NotificationsEvent {
  final String? userId;

  const NotificationsMarkAllAsReadRequested([this.userId]);
}

final class NotificationsClearReadRequested extends NotificationsEvent {
  final String? userId;

  const NotificationsClearReadRequested([this.userId]);
}

final class NotificationsPopupConsumed extends NotificationsEvent {
  const NotificationsPopupConsumed();
}
