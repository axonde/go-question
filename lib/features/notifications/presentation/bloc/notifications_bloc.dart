import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/notifications/domain/entities/notification_entity.dart';
import 'package:go_question/features/notifications/domain/errors/notification_failures.dart';
import 'package:go_question/features/notifications/domain/repositories/i_notifications_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final INotificationsRepository _repository;

  StreamSubscription<List<NotificationEntity>>? _notificationsSubscription;
  final Set<String> _knownNotificationIds = <String>{};
  bool _streamPrimed = false;

  NotificationsBloc(this._repository)
    : super(const NotificationsState.initial()) {
    on<NotificationsStarted>(_onStarted);
    on<_NotificationsStreamUpdated>(_onStreamUpdated);
    on<NotificationsMarkAsReadRequested>(_onMarkAsReadRequested);
    on<NotificationsMarkAllAsReadRequested>(_onMarkAllAsReadRequested);
    on<NotificationsClearReadRequested>(_onClearReadRequested);
    on<NotificationsPopupConsumed>(_onPopupConsumed);
  }

  Future<void> _onStarted(
    NotificationsStarted event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: NotificationsStatus.loading,
        activeUserId: event.userId,
        clearError: true,
      ),
    );

    await _notificationsSubscription?.cancel();
    _knownNotificationIds..clear();
    _streamPrimed = false;

    _notificationsSubscription = _repository
        .watchNotifications(event.userId)
        .listen(
          (notifications) => add(_NotificationsStreamUpdated(notifications)),
        );

    final result = await _repository.getNotifications(event.userId);
    result.fold(
      onSuccess: (notifications) {
        _knownNotificationIds.addAll(
          notifications.map((notification) => notification.id),
        );
        emit(
          state.copyWith(
            status: NotificationsStatus.success,
            notifications: notifications,
            clearError: true,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: NotificationsStatus.failure,
            errorMessage: _mapFailureMessage(failure),
          ),
        );
      },
    );
  }

  void _onStreamUpdated(
    _NotificationsStreamUpdated event,
    Emitter<NotificationsState> emit,
  ) {
    NotificationEntity? popupNotification;

    if (_streamPrimed) {
      final newNotifications = event.notifications
          .where(
            (notification) => !_knownNotificationIds.contains(notification.id),
          )
          .toList(growable: false);

      if (newNotifications.isNotEmpty) {
        popupNotification = newNotifications.first;
      }
    } else {
      _streamPrimed = true;
    }

    _knownNotificationIds
      ..clear()
      ..addAll(event.notifications.map((notification) => notification.id));

    emit(
      state.copyWith(
        status: NotificationsStatus.success,
        notifications: event.notifications,
        popupNotification: popupNotification,
        clearError: true,
      ),
    );
  }

  Future<void> _onMarkAsReadRequested(
    NotificationsMarkAsReadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await _repository.markAsRead(event.notificationId);

    result.fold(
      onSuccess: (_) {
        final updated = state.notifications
            .map(
              (notification) => notification.id == event.notificationId
                  ? notification.copyWith(isRead: true)
                  : notification,
            )
            .toList(growable: false);

        emit(
          state.copyWith(
            status: NotificationsStatus.success,
            notifications: updated,
            clearError: true,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: NotificationsStatus.failure,
            errorMessage: _mapFailureMessage(failure),
          ),
        );
      },
    );
  }

  Future<void> _onMarkAllAsReadRequested(
    NotificationsMarkAllAsReadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    final userId = event.userId ?? state.activeUserId;
    if (userId == null || userId.trim().isEmpty) {
      return;
    }

    final result = await _repository.markAllAsRead(userId);

    result.fold(
      onSuccess: (_) {
        final updated = state.notifications
            .map((notification) => notification.copyWith(isRead: true))
            .toList(growable: false);

        emit(
          state.copyWith(
            status: NotificationsStatus.success,
            notifications: updated,
            clearError: true,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: NotificationsStatus.failure,
            errorMessage: _mapFailureMessage(failure),
          ),
        );
      },
    );
  }

  Future<void> _onClearReadRequested(
    NotificationsClearReadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    final userId = event.userId ?? state.activeUserId;
    if (userId == null || userId.trim().isEmpty) {
      return;
    }

    final result = await _repository.clearRead(userId);

    result.fold(
      onSuccess: (_) {
        final updated = state.notifications
            .where((notification) => !notification.isRead)
            .toList(growable: false);

        emit(
          state.copyWith(
            status: NotificationsStatus.success,
            notifications: updated,
            clearError: true,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: NotificationsStatus.failure,
            errorMessage: _mapFailureMessage(failure),
          ),
        );
      },
    );
  }

  void _onPopupConsumed(
    NotificationsPopupConsumed event,
    Emitter<NotificationsState> emit,
  ) {
    if (state.popupNotification == null) {
      return;
    }

    emit(state.copyWith(clearPopup: true));
  }

  String _mapFailureMessage(NotificationFailure failure) {
    switch (failure.type) {
      case NotificationFailureType.notFound:
        return 'Уведомление не найдено';
      case NotificationFailureType.fetchFailed:
        return 'Не удалось загрузить уведомления';
      case NotificationFailureType.updateFailed:
        return 'Не удалось обновить уведомления';
    }
  }

  @override
  Future<void> close() async {
    await _notificationsSubscription?.cancel();
    return super.close();
  }
}
