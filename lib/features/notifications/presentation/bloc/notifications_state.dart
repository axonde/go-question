part of 'notifications_bloc.dart';

enum NotificationsStatus { initial, loading, success, failure }

class NotificationsState {
  final NotificationsStatus status;
  final List<NotificationEntity> notifications;
  final String? activeUserId;
  final String? errorMessage;
  final NotificationEntity? popupNotification;

  const NotificationsState({
    required this.status,
    this.notifications = const <NotificationEntity>[],
    this.activeUserId,
    this.errorMessage,
    this.popupNotification,
  });

  const NotificationsState.initial()
    : status = NotificationsStatus.initial,
      notifications = const <NotificationEntity>[],
      activeUserId = null,
      errorMessage = null,
      popupNotification = null;

  int get unreadCount =>
      notifications.where((notification) => !notification.isRead).length;

  bool get hasUnread => unreadCount > 0;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationEntity>? notifications,
    String? activeUserId,
    String? errorMessage,
    NotificationEntity? popupNotification,
    bool clearError = false,
    bool clearPopup = false,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      activeUserId: activeUserId ?? this.activeUserId,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      popupNotification: clearPopup
          ? null
          : (popupNotification ?? this.popupNotification),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is NotificationsState &&
        other.status == status &&
        other.activeUserId == activeUserId &&
        other.errorMessage == errorMessage &&
        other.popupNotification == popupNotification &&
        _listEquals(other.notifications, notifications);
  }

  @override
  int get hashCode {
    return status.hashCode ^
        notifications.hashCode ^
        activeUserId.hashCode ^
        errorMessage.hashCode ^
        popupNotification.hashCode;
  }

  bool _listEquals(List<NotificationEntity> a, List<NotificationEntity> b) {
    if (a.length != b.length) {
      return false;
    }

    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }

    return true;
  }
}
