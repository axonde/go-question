# Быстрое подключение Firestore для уведомлений

## Шаг 1: Раскомментируйте в `injection_container.dart`

Файл: `lib/injection_container/injection_container.dart`

Найдите секцию `//! Features - Notifications` и раскомментируйте:

```dart
sl.registerLazySingleton<INotificationsRemoteDataSource>(
  () => NotificationsRemoteDataSourceImpl(sl()),
);
sl.registerLazySingleton<INotificationsRepository>(
  () => NotificationsRepositoryImpl(sl()),
);
```

Добавьте импорты в начало файла:

```dart
import 'package:go_question/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:go_question/features/notifications/data/source/notifications_remote_data_source.dart';
import 'package:go_question/features/notifications/domain/repositories/i_notifications_repository.dart';
```

## Шаг 2: Обновите `notifications_sheet.dart`

Файл: `lib/features/home/presentation/widgets/notifications_sheet.dart`

Замените:
```dart
final _mockDataSource = NotificationsMockDataSource();
```

На:
```dart
// Импортируйте GetIt
import 'package:go_question/injection_container/injection_container.dart';

// Получите репозиторий
final _repository = sl<INotificationsRepository>();
```

Обновите метод `_loadNotifications()`:

```dart
Future<void> _loadNotifications() async {
  try {
    // TODO: Замените на реальный userId из auth
    final userId = 'current_user_id';
    final result = await _repository.getNotifications(userId);
    
    result.when(
      success: (entities) {
        setState(() {
          _notifications = entities.map(NotificationData.fromEntity).toList();
          _isLoading = false;
        });
      },
      failure: (failure) {
        setState(() {
          _notifications = [];
          _isLoading = false;
        });
      },
    );
  } catch (e) {
    setState(() {
      _notifications = [];
      _isLoading = false;
    });
  }
}
```

## Шаг 3: Создайте индекс в Firestore

В Firebase Console → Firestore → Indexes:

- Collection ID: `notifications`
- Fields:
  - `userId` (Ascending)
  - `createdAt` (Descending)

## Шаг 4: Добавьте тестовые данные (опционально)

Создайте документ в коллекции `notifications`:

```json
{
  "userId": "your_test_user_id",
  "title": "Тестовое уведомление",
  "body": "Это тестовое уведомление из Firestore",
  "type": "system",
  "isRead": false,
  "createdAt": "2027-04-08T12:00:00Z"
}
```

## Готово!

Теперь уведомления загружаются из Firestore вместо моков.
