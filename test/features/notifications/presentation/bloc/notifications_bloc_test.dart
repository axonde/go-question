import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/notifications/domain/entities/notification_entity.dart';
import 'package:go_question/features/notifications/domain/errors/notification_failures.dart';
import 'package:go_question/features/notifications/domain/repositories/i_notifications_repository.dart';
import 'package:go_question/features/notifications/presentation/bloc/notifications_bloc.dart';

class FakeNotificationsRepository implements INotificationsRepository {
  final StreamController<List<NotificationEntity>> _controller =
      StreamController<List<NotificationEntity>>.broadcast();

  Result<List<NotificationEntity>, NotificationFailure>? getNotificationsResult;
  Result<void, NotificationFailure>? markAsReadResult;
  Result<void, NotificationFailure>? markAllAsReadResult;
  Result<void, NotificationFailure>? clearReadResult;

  List<NotificationEntity> notifications = <NotificationEntity>[];

  @override
  Future<Result<List<NotificationEntity>, NotificationFailure>>
  getNotifications(String userId) async {
    return getNotificationsResult ?? Success(notifications);
  }

  @override
  Stream<List<NotificationEntity>> watchNotifications(String userId) {
    return _controller.stream;
  }

  @override
  Future<Result<void, NotificationFailure>> markAsRead(
    String notificationId,
  ) async {
    final forcedResult = markAsReadResult;
    if (forcedResult != null) {
      return forcedResult;
    }

    notifications = notifications
        .map(
          (notification) => notification.id == notificationId
              ? notification.copyWith(isRead: true)
              : notification,
        )
        .toList(growable: false);
    _controller.add(notifications);
    return const Success(null);
  }

  @override
  Future<Result<void, NotificationFailure>> markAllAsRead(String userId) async {
    final forcedResult = markAllAsReadResult;
    if (forcedResult != null) {
      return forcedResult;
    }

    notifications = notifications
        .map((notification) => notification.copyWith(isRead: true))
        .toList(growable: false);
    _controller.add(notifications);
    return const Success(null);
  }

  @override
  Future<Result<void, NotificationFailure>> clearRead(String userId) async {
    final forcedResult = clearReadResult;
    if (forcedResult != null) {
      return forcedResult;
    }

    notifications = notifications
        .where((notification) => !notification.isRead)
        .toList(growable: false);
    _controller.add(notifications);
    return const Success(null);
  }

  @override
  Future<Result<void, NotificationFailure>> clearAll(String userId) async {
    notifications = const <NotificationEntity>[];
    _controller.add(notifications);
    return const Success(null);
  }

  void emit(List<NotificationEntity> nextNotifications) {
    notifications = nextNotifications;
    _controller.add(notifications);
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}

NotificationEntity _notification({
  required String id,
  required bool isRead,
  String title = 'Title',
}) {
  return NotificationEntity(
    id: id,
    userId: 'uid-1',
    title: title,
    body: 'Body',
    type: NotificationType.system,
    isRead: isRead,
    createdAt: DateTime.utc(2026),
  );
}

void main() {
  late FakeNotificationsRepository repository;
  late NotificationsBloc bloc;

  Future<void> settle() async {
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }

  setUp(() {
    repository = FakeNotificationsRepository();
    bloc = NotificationsBloc(repository);
  });

  tearDown(() async {
    await bloc.close();
    await repository.dispose();
  });

  test('loads notifications and exposes unread for badge', () async {
    final unread = _notification(id: 'n1', isRead: false);
    repository.notifications = <NotificationEntity>[unread];

    bloc.add(const NotificationsStarted('uid-1'));
    await settle();

    expect(bloc.state.status, NotificationsStatus.success);
    expect(bloc.state.notifications, <NotificationEntity>[unread]);
    expect(bloc.state.unreadCount, 1);
    expect(bloc.state.hasUnread, isTrue);
  });

  test('stream update with new notification emits popup event', () async {
    final first = _notification(id: 'n1', isRead: false, title: 'Old');
    final second = _notification(id: 'n2', isRead: false, title: 'New');
    repository.notifications = <NotificationEntity>[first];

    bloc.add(const NotificationsStarted('uid-1'));
    await settle();

    repository.emit(<NotificationEntity>[first]);
    await settle();
    expect(bloc.state.popupNotification, isNull);

    repository.emit(<NotificationEntity>[second, first]);
    await settle();

    expect(bloc.state.notifications.length, 2);
    expect(bloc.state.popupNotification?.id, 'n2');
  });

  test('mark as read clears unread badge state', () async {
    final unread = _notification(id: 'n1', isRead: false);
    repository.notifications = <NotificationEntity>[unread];

    bloc.add(const NotificationsStarted('uid-1'));
    await settle();

    bloc.add(const NotificationsMarkAsReadRequested('n1'));
    await settle();

    expect(bloc.state.notifications.single.isRead, isTrue);
    expect(bloc.state.hasUnread, isFalse);
  });

  test('clear read removes only read notifications', () async {
    final read = _notification(id: 'read', isRead: true);
    final unread = _notification(id: 'unread', isRead: false);
    repository.notifications = <NotificationEntity>[read, unread];

    bloc.add(const NotificationsStarted('uid-1'));
    await settle();

    bloc.add(const NotificationsClearReadRequested());
    await settle();

    expect(bloc.state.notifications.length, 1);
    expect(bloc.state.notifications.single.id, 'unread');
    expect(bloc.state.notifications.single.isRead, isFalse);
  });

  test('mark as read failure is mapped to failure state', () async {
    final unread = _notification(id: 'n1', isRead: false);
    repository.notifications = <NotificationEntity>[unread];
    repository.markAsReadResult = const Failure(
      NotificationFailure(NotificationFailureType.updateFailed),
    );

    bloc.add(const NotificationsStarted('uid-1'));
    await settle();

    bloc.add(const NotificationsMarkAsReadRequested('n1'));
    await settle();

    expect(bloc.state.status, NotificationsStatus.failure);
    expect(bloc.state.errorMessage, 'Не удалось обновить уведомления');
  });
}
