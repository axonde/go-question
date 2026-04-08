# Notifications Feature

Модуль уведомлений для приложения go-question.

## Архитектура

Следует Clean Architecture с разделением на слои:

```
notifications/
├── domain/              # Бизнес-логика
│   ├── entities/        # NotificationEntity (freezed)
│   ├── repositories/    # INotificationsRepository (интерфейс)
│   └── errors/          # Exceptions и Failures
├── data/                # Реализация данных
│   ├── models/          # Маппинг Firestore ↔ Entity
│   ├── source/          # Data sources (Firestore + Mock)
│   ├── repositories/    # NotificationsRepositoryImpl
│   └── constants/       # Константы коллекций
└── presentation/        # UI (пока в home/presentation/widgets)
```

## Переключение на Firestore

### Текущее состояние (Mock)

Сейчас используется `NotificationsMockDataSource` для тестирования без Firestore.

### Шаги для подключения Firestore

1. **Откройте `lib/injection_container/injection_container.dart`**

2. **Добавьте регистрацию зависимостей:**

```dart
// Data sources
sl.registerLazySingleton<INotificationsRemoteDataSource>(
  () => NotificationsRemoteDataSourceImpl(sl()),
);

// Repositories
sl.registerLazySingleton<INotificationsRepository>(
  () => NotificationsRepositoryImpl(sl()),
);
```

3. **В `lib/features/home/presentation/widgets/notifications_sheet.dart`:**

Замените:
```dart
final _mockDataSource = NotificationsMockDataSource();
```

На:
```dart
// Получите репозиторий через DI
final _repository = sl<INotificationsRepository>();
```

И обновите метод `_loadNotifications()`:
```dart
Future<void> _loadNotifications() async {
  try {
    final userId = 'current_user_id'; // TODO: получить из auth
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

## Структура данных Firestore

### Коллекция: `notifications`

```json
{
  "userId": "string",           // ID пользователя-получателя
  "title": "string",            // Заголовок уведомления
  "body": "string",             // Текст уведомления
  "type": "join_request",       // Тип: join_request, event_reminder, message, system
  "isRead": false,              // Прочитано ли
  "createdAt": Timestamp,       // Дата создания
  
  // Опциональные поля для запросов на участие
  "requestUserId": "string",
  "requestUserName": "string",
  "requestUserRating": "string",
  "requestUserAge": "string",
  "requestUserGender": "string",
  "requestUserCity": "string",
  "requestUserBio": "string",
  "requestUserEventsAttended": 24,
  "requestUserEventsOrganized": 3,
  
  // Опциональные поля для событий
  "eventId": "string",
  "eventTitle": "string",
  "eventDate": "string",
  "eventLocation": "string",
  "eventCategory": "string"
}
```

### Индексы Firestore

Создайте составной индекс:
- Collection: `notifications`
- Fields: `userId` (Ascending), `createdAt` (Descending)

## Типы уведомлений

```dart
enum NotificationType {
  joinRequest,      // Запрос на участие в событии
  eventReminder,    // Напоминание о событии
  message,          // Сообщение от пользователя
  system,           // Системное уведомление
}
```

## API

### INotificationsRepository

```dart
// Получить все уведомления пользователя
Future<Result<List<NotificationEntity>, NotificationFailure>> 
  getNotifications(String userId);

// Отметить уведомление как прочитанное
Future<Result<void, NotificationFailure>> 
  markAsRead(String notificationId);

// Отметить все уведомления как прочитанные
Future<Result<void, NotificationFailure>> 
  markAllAsRead(String userId);
```

## Тестирование

Mock data source предоставляет 3 тестовых уведомления:
1. Запрос на участие от "Джиган"
2. Напоминание о событии "Вечеринка на пляже"
3. Сообщение от "Организатор Иван"

## TODO

- [ ] Подключить реальный userId из auth
- [ ] Добавить BLoC для управления состоянием
- [ ] Реализовать real-time обновления через Firestore streams
- [ ] Добавить push-уведомления через FCM
- [ ] Реализовать действия "Принять"/"Отклонить" для запросов
- [ ] Добавить фильтрацию по типам уведомлений
- [ ] Реализовать пагинацию для больших списков
