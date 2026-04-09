# Quickstart: Adding a New BLoC Feature

**For**: go-question project  
**When to use**: Creating a new feature in `lib/features/<feature>/`  
**Strictness**: `standard` — Apply layer-first pattern  
**Time estimate**: 2–4 hours for domain + data layer (with tests)

---

## Overview

This guide walks through adding a complete BLoC feature following the project's **layer-first delivery order**:

1. **Domain** — Define contracts (entities, failures, repository interfaces)
2. **Data** — Implement concrete repositories and datasources
3. **Presentation** — Connect BLoC and UI

---

## Example: Adding "User Notifications" Feature

We'll build a feature that allows users to view and manage their notifications.

### Step 1: Create Feature Directory Structure

```bash
mkdir -p lib/features/notifications/{domain,data,presentation}

mkdir -p lib/features/notifications/domain/{entities,failures,repositories}
mkdir -p lib/features/notifications/data/{datasources,repositories,mappers}
mkdir -p lib/features/notifications/presentation/{bloc,screens,widgets}

mkdir -p test/features/notifications/{domain,data,presentation}
```

Result:
```
lib/features/notifications/
├── domain/
│   ├── entities/
│   │   ├── notification.dart
│   │   └── notification_type.dart
│   ├── failures/
│   │   └── notification_failure.dart
│   └── repositories/
│       └── notifications_repository.dart
├── data/
│   ├── datasources/
│   │   └── notifications_datasource.dart
│   ├── repositories/
│   │   └── notifications_repository_impl.dart
│   └── mappers/
│       ├── notification_mapper.dart
│       └── exception_to_failure_mapper.dart
└── presentation/
    ├── bloc/
    │   ├── notifications_bloc.dart
    │   ├── notifications_event.dart
    │   └── notifications_state.dart
    ├── screens/
    │   └── notifications_screen.dart
    └── widgets/
        └── notification_tile.dart
```

---

## Layer 1: Domain (Contracts)

### 1.1 Define Entities

```dart
// lib/features/notifications/domain/entities/notification.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'notification_type.dart';

part 'notification.freezed.dart';

@freezed
class Notification with _$Notification {
  const factory Notification({
    required String id,
    required String userId,
    required String title,
    required String message,
    required NotificationType type,
    required bool isRead,
    required DateTime createdAt,
    DateTime? readAt,
    String? actionUrl,
  }) = _Notification;
}
```

```dart
// lib/features/notifications/domain/entities/notification_type.dart
enum NotificationType {
  friendRequest,
  eventInvite,
  scoreUpdate,
  achievement,
  system,
}
```

### 1.2 Define Failures

```dart
// lib/features/notifications/domain/failures/notification_failure.dart
import 'package:go_question/core/failures/failure.dart';

sealed class NotificationFailure extends Failure<NotificationFailure> {
  const NotificationFailure();

  factory NotificationFailure.fromException(Exception exception) {
    // Map exceptions to failures
    return NotificationFailure.unknown(exception.toString());
  }

  const factory NotificationFailure.networkError() = _NetworkError;
  const factory NotificationFailure.notFound() = _NotFound;
  const factory NotificationFailure.permissionDenied() = _PermissionDenied;
  const factory NotificationFailure.unknown(String message) = _Unknown;
}

class _NetworkError extends NotificationFailure {
  const _NetworkError();
}

class _NotFound extends NotificationFailure {
  const _NotFound();
}

class _PermissionDenied extends NotificationFailure {
  const _PermissionDenied();
}

class _Unknown extends NotificationFailure {
  final String message;
  const _Unknown(this.message);
}
```

### 1.3 Define Repository Interface

```dart
// lib/features/notifications/domain/repositories/notifications_repository.dart
import 'package:go_question/core/models/result.dart';
import '../entities/notification.dart';
import '../failures/notification_failure.dart';

abstract class NotificationsRepository {
  /// Fetch all notifications for current user
  Future<Result<List<Notification>, NotificationFailure>> getNotifications();

  /// Mark notification as read
  Future<Result<void, NotificationFailure>> markAsRead(String notificationId);

  /// Delete a notification
  Future<Result<void, NotificationFailure>> deleteNotification(String notificationId);

  /// Clear all notifications
  Future<Result<void, NotificationFailure>> clearAllNotifications();

  /// Get unread count
  Future<Result<int, NotificationFailure>> getUnreadCount();
}
```

✅ **Checkpoint**: Domain layer is now locked and ready for data implementation.

---

## Layer 2: Data (Implementations)

### 2.1 Create Data Source (Firebase Access)

```dart
// lib/features/notifications/data/datasources/notifications_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class NotificationsDataSource {
  Future<List<Map<String, dynamic>>> getNotifications(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> deleteNotification(String notificationId);
  Future<void> clearAllNotifications(String userId);
  Future<int> getUnreadCount(String userId);
}

class NotificationsDataSourceImpl implements NotificationsDataSource {
  final FirebaseFirestore _firestore;

  NotificationsDataSourceImpl(this._firestore);

  @override
  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch notifications: ${e.message}');
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      final userId = _getCurrentUserId();
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .update({
            'isRead': true,
            'readAt': FieldValue.serverTimestamp(),
          });
    } on FirebaseException catch (e) {
      throw Exception('Failed to mark as read: ${e.message}');
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    try {
      final userId = _getCurrentUserId();
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete notification: ${e.message}');
    }
  }

  @override
  Future<void> clearAllNotifications(String userId) async {
    try {
      final batch = _firestore.batch();
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .get();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } on FirebaseException catch (e) {
      throw Exception('Failed to clear notifications: ${e.message}');
    }
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .where('isRead', isEqualTo: false)
          .count()
          .get();

      return snapshot.count ?? 0;
    } on FirebaseException catch (e) {
      throw Exception('Failed to get unread count: ${e.message}');
    }
  }

  String _getCurrentUserId() {
    // Get from auth service or context
    throw UnimplementedError('Implement with actual user ID source');
  }
}
```

### 2.2 Create Mappers

```dart
// lib/features/notifications/data/mappers/notification_mapper.dart
import 'package:go_question/features/notifications/domain/entities/notification.dart';
import 'package:go_question/features/notifications/domain/entities/notification_type.dart';

class NotificationMapper {
  static Notification toDomain(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: _parseType(json['type'] as String),
      isRead: json['isRead'] as bool? ?? false,
      createdAt: _parseDateTime(json['createdAt']),
      readAt: _parseDateTime(json['readAt']),
      actionUrl: json['actionUrl'] as String?,
    );
  }

  static NotificationType _parseType(String typeStr) {
    return NotificationType.values.firstWhere(
      (t) => t.name == typeStr,
      orElse: () => NotificationType.system,
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }
}
```

```dart
// lib/features/notifications/data/mappers/exception_to_failure_mapper.dart
import 'package:go_question/features/notifications/domain/failures/notification_failure.dart';

class ExceptionToFailureMapper {
  static NotificationFailure map(Exception exception) {
    if (exception is FirebaseException) {
      switch (exception.code) {
        case 'permission-denied':
          return NotificationFailure.permissionDenied();
        case 'not-found':
          return NotificationFailure.notFound();
        default:
          return NotificationFailure.networkError();
      }
    }

    return NotificationFailure.unknown(exception.toString());
  }
}
```

### 2.3 Implement Repository

```dart
// lib/features/notifications/data/repositories/notifications_repository_impl.dart
import 'package:go_question/core/models/result.dart';
import 'package:go_question/features/notifications/domain/entities/notification.dart';
import 'package:go_question/features/notifications/domain/failures/notification_failure.dart';
import 'package:go_question/features/notifications/domain/repositories/notifications_repository.dart';
import '../datasources/notifications_datasource.dart';
import '../mappers/notification_mapper.dart';
import '../mappers/exception_to_failure_mapper.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsDataSource _dataSource;
  final String _userId; // Inject from auth context

  NotificationsRepositoryImpl(this._dataSource, this._userId);

  @override
  Future<Result<List<Notification>, NotificationFailure>> getNotifications() async {
    try {
      final data = await _dataSource.getNotifications(_userId);
      final notifications = data.map(NotificationMapper.toDomain).toList();
      return Result.success(notifications);
    } catch (e) {
      return Result.failure(
        ExceptionToFailureMapper.map(e as Exception),
      );
    }
  }

  @override
  Future<Result<void, NotificationFailure>> markAsRead(
    String notificationId,
  ) async {
    try {
      await _dataSource.markAsRead(notificationId);
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        ExceptionToFailureMapper.map(e as Exception),
      );
    }
  }

  @override
  Future<Result<void, NotificationFailure>> deleteNotification(
    String notificationId,
  ) async {
    try {
      await _dataSource.deleteNotification(notificationId);
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        ExceptionToFailureMapper.map(e as Exception),
      );
    }
  }

  @override
  Future<Result<void, NotificationFailure>> clearAllNotifications() async {
    try {
      await _dataSource.clearAllNotifications(_userId);
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        ExceptionToFailureMapper.map(e as Exception),
      );
    }
  }

  @override
  Future<Result<int, NotificationFailure>> getUnreadCount() async {
    try {
      final count = await _dataSource.getUnreadCount(_userId);
      return Result.success(count);
    } catch (e) {
      return Result.failure(
        ExceptionToFailureMapper.map(e as Exception),
      );
    }
  }
}
```

✅ **Checkpoint**: Data layer is complete. Domain contracts are unchanged. Ready for BLoC.

---

## Layer 3: Presentation (BLoC + UI)

### 3.1 Define BLoC Events & States

```dart
// lib/features/notifications/presentation/bloc/notifications_event.dart
part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class FetchNotificationsEvent extends NotificationsEvent {
  const FetchNotificationsEvent();
}

class MarkAsReadEvent extends NotificationsEvent {
  final String notificationId;
  const MarkAsReadEvent(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class DeleteNotificationEvent extends NotificationsEvent {
  final String notificationId;
  const DeleteNotificationEvent(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class ClearAllEvent extends NotificationsEvent {
  const ClearAllEvent();
}
```

```dart
// lib/features/notifications/presentation/bloc/notifications_state.dart
part of 'notifications_bloc.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsLoaded extends NotificationsState {
  final List<Notification> notifications;
  final int unreadCount;

  const NotificationsLoaded({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object> get props => [notifications, unreadCount];
}

class NotificationsError extends NotificationsState {
  final NotificationFailure failure;
  const NotificationsError(this.failure);

  @override
  List<Object> get props => [failure];
}
```

### 3.2 Implement BLoC

```dart
// lib/features/notifications/presentation/bloc/notifications_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_question/features/notifications/domain/entities/notification.dart';
import 'package:go_question/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:go_question/features/notifications/domain/failures/notification_failure.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsRepository _repository;

  NotificationsBloc(this._repository)
      : super(const NotificationsInitial()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<MarkAsReadEvent>(_onMarkAsRead);
    on<DeleteNotificationEvent>(_onDeleteNotification);
    on<ClearAllEvent>(_onClearAll);
  }

  Future<void> _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(const NotificationsLoading());

    final result = await _repository.getNotifications();
    final unreadResult = await _repository.getUnreadCount();

    result.fold(
      (notifications) {
        final unread = unreadResult.getOrNull() ?? 0;
        emit(NotificationsLoaded(
          notifications: notifications,
          unreadCount: unread,
        ));
      },
      (failure) => emit(NotificationsError(failure)),
    );
  }

  Future<void> _onMarkAsRead(
    MarkAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is! NotificationsLoaded) return;

    final currentState = state as NotificationsLoaded;

    final result = await _repository.markAsRead(event.notificationId);

    result.fold(
      (_) {
        // Update local state
        final updated = currentState.notifications.map((n) {
          return n.id == event.notificationId
              ? n.copyWith(isRead: true)
              : n;
        }).toList();

        emit(NotificationsLoaded(
          notifications: updated,
          unreadCount: currentState.unreadCount - 1,
        ));
      },
      (failure) => emit(NotificationsError(failure)),
    );
  }

  Future<void> _onDeleteNotification(
    DeleteNotificationEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is! NotificationsLoaded) return;

    final currentState = state as NotificationsLoaded;

    final result = await _repository.deleteNotification(event.notificationId);

    result.fold(
      (_) {
        final updated = currentState.notifications
            .where((n) => n.id != event.notificationId)
            .toList();

        emit(NotificationsLoaded(
          notifications: updated,
          unreadCount: currentState.unreadCount,
        ));
      },
      (failure) => emit(NotificationsError(failure)),
    );
  }

  Future<void> _onClearAll(
    ClearAllEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await _repository.clearAllNotifications();

    result.fold(
      (_) => emit(const NotificationsLoaded(
        notifications: [],
        unreadCount: 0,
      )),
      (failure) => emit(NotificationsError(failure)),
    );
  }
}
```

### 3.3 Create Screen

```dart
// lib/features/notifications/presentation/screens/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/features/notifications/presentation/bloc/notifications_bloc.dart';
import '../widgets/notification_tile.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              if (state is NotificationsLoaded && state.notifications.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        context.read<NotificationsBloc>().add(const ClearAllEvent());
                      },
                      child: const Text('Clear All'),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsInitial) {
            context.read<NotificationsBloc>().add(const FetchNotificationsEvent());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load notifications'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<NotificationsBloc>()
                          .add(const FetchNotificationsEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is NotificationsLoaded) {
            if (state.notifications.isEmpty) {
              return const Center(child: Text('No notifications'));
            }

            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return NotificationTile(
                  notification: notification,
                  onTap: () {
                    context.read<NotificationsBloc>()
                        .add(MarkAsReadEvent(notification.id));
                  },
                  onDelete: () {
                    context.read<NotificationsBloc>()
                        .add(DeleteNotificationEvent(notification.id));
                  },
                );
              },
            );
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }
}
```

### 3.4 Register in DI & Router

```dart
// lib/injection_container/injection_container.dart (add these)
void setupNotificationsFeature() {
  // Data sources
  getIt.registerSingleton<NotificationsDataSource>(
    NotificationsDataSourceImpl(FirebaseFirestore.instance),
  );

  // Repositories
  getIt.registerSingleton<NotificationsRepository>(
    NotificationsRepositoryImpl(
      getIt<NotificationsDataSource>(),
      _getCurrentUserId(), // Get from auth service
    ),
  );

  // BLoC
  getIt.registerSingleton<NotificationsBloc>(
    NotificationsBloc(getIt<NotificationsRepository>()),
  );
}
```

```dart
// lib/config/router/router.dart (add this route)
@MaterialAutoRouter(
  routes: [
    // ... existing routes
    AutoRoute(
      page: NotificationsRoute.page,
      path: '/notifications',
      guards: [AuthGuard()],
    ),
  ],
)
class $AppRouter {}
```

---

## Step 4: Write Critical Tests

```dart
// test/features/notifications/data/repositories/notifications_repository_test.dart
void main() {
  group('NotificationsRepository', () {
    late MockNotificationsDataSource mockDataSource;
    late NotificationsRepositoryImpl repository;

    setUp(() {
      mockDataSource = MockNotificationsDataSource();
      repository = NotificationsRepositoryImpl(mockDataSource, 'user123');
    });

    test('getNotifications returns mapped notifications on success', () async {
      final mockData = [
        {
          'id': '1',
          'title': 'Test',
          'message': 'Test message',
          'type': 'system',
          'isRead': false,
          'createdAt': DateTime.now(),
        },
      ];

      when(mockDataSource.getNotifications('user123'))
          .thenAnswer((_) async => mockData);

      final result = await repository.getNotifications();

      expect(result.isSuccess, true);
      expect(result.getOrNull(), isA<List<Notification>>());
    });

    test('getNotifications returns failure on exception', () async {
      when(mockDataSource.getNotifications('user123'))
          .thenThrow(Exception('Network error'));

      final result = await repository.getNotifications();

      expect(result.isFailure, true);
      expect(result.getErrorOrNull(), isA<NotificationFailure>());
    });
  });
}
```

```dart
// test/features/notifications/presentation/bloc/notifications_bloc_test.dart
void main() {
  group('NotificationsBloc', () {
    late MockNotificationsRepository mockRepository;
    late NotificationsBloc bloc;

    setUp(() {
      mockRepository = MockNotificationsRepository();
      bloc = NotificationsBloc(mockRepository);
    });

    blocTest<NotificationsBloc, NotificationsState>(
      'emit Loading then Loaded on FetchNotificationsEvent',
      build: () {
        when(mockRepository.getNotifications()).thenAnswer(
          (_) async => Result.success([
            Notification(
              id: '1',
              userId: 'user1',
              title: 'Test',
              message: 'Test message',
              type: NotificationType.system,
              isRead: false,
              createdAt: DateTime.now(),
            ),
          ]),
        );
        when(mockRepository.getUnreadCount())
            .thenAnswer((_) async => Result.success(1));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchNotificationsEvent()),
      expect: () => [
        isA<NotificationsLoading>(),
        isA<NotificationsLoaded>(),
      ],
    );
  });
}
```

---

## Step 5: Run Quality Gate

```bash
# From project root
flutter analyze
flutter test test/features/notifications/
dart format --set-exit-if-changed lib/features/notifications test/features/notifications
```

---

## Checklist

- [ ] Domain layer defined (entities, failures, repository interface)
- [ ] Data layer implemented (datasource, mappers, repository impl)
- [ ] Domain and data layer tests passing
- [ ] BLoC implemented with all event handlers
- [ ] Screen built with BLoC listeners
- [ ] DI container registration added
- [ ] Router route added with guards
- [ ] BLoC/presentation tests passing
- [ ] flutter analyze passes
- [ ] dart format passes
- [ ] No unhandled exceptions in data layer

---

## Next Steps

- Add real-time listeners (Firestore streams) if needed
- Implement pagination for large notification lists
- Add notification badges/indicators
- Set up push notifications

---

**Last updated**: 2026-04-08
