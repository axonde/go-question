import 'package:go_question/features/notifications/data/source/notifications_remote_data_source.dart';
import 'package:go_question/features/notifications/domain/entities/notification_entity.dart';

/// Mock data source для тестирования без Firestore.
/// Чтобы переключиться на Firestore, замените в injection_container.dart:
/// NotificationsMockDataSource() -> NotificationsRemoteDataSourceImpl(sl())
class NotificationsMockDataSource implements INotificationsRemoteDataSource {
  final List<NotificationEntity> _mockNotifications = [
    NotificationEntity(
      id: '1',
      userId: 'current-user-id',
      title: 'Запрос на участие',
      body:
          'Джиган хочет присоединиться к вашему ивенту: "Вечеринка на пляже", который состоится 04.04.2027 в 17:00.',
      type: NotificationType.joinRequest,
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      requestUserId: 'user_123',
      requestUserName: 'Джиган',
      requestUserRating: '158 🏆',
      requestUserAge: '28 лет',
      requestUserGender: 'Мужской',
      requestUserCity: 'Санкт-Петербург',
      requestUserBio:
          'Люблю активный отдых, спорт и новые знакомства. Участвую в мероприятиях уже 2 года.',
      requestUserEventsAttended: 24,
      requestUserEventsOrganized: 3,
      eventId: 'event_456',
      eventTitle: 'Вечеринка на пляже',
      eventDate: '04.04.2027 в 17:00',
      eventLocation: 'Пляж "Ласковый берег", Санкт-Петербург',
      eventCategory: 'Отдых и развлечения',
    ),
    NotificationEntity(
      id: '2',
      userId: 'current-user-id',
      title: 'Событие скоро начнется!',
      body:
          'Событие "Вечеринка на пляже", которое состоится 04.04.2027 в 17:00, начнется через 2 часа. Не забудьте подготовиться!',
      type: NotificationType.eventReminder,
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      eventId: 'event_456',
      eventTitle: 'Вечеринка на пляже',
      eventDate: '04.04.2027 в 17:00',
      eventLocation: 'Пляж "Ласковый берег", Санкт-Петербург',
      eventCategory: 'Отдых и развлечения',
    ),
    NotificationEntity(
      id: '3',
      userId: 'current-user-id',
      title: 'Новое сообщение',
      body: 'У вас новое сообщение от организатора турнира.',
      type: NotificationType.message,
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      requestUserId: 'user_789',
      requestUserName: 'Организатор Иван',
      requestUserRating: '245 🏆',
      requestUserAge: '35 лет',
      requestUserGender: 'Мужской',
      requestUserCity: 'Москва',
      requestUserBio:
          'Профессиональный организатор спортивных мероприятий. Опыт работы 5 лет.',
      requestUserEventsAttended: 15,
      requestUserEventsOrganized: 42,
      eventId: 'event_789',
      eventTitle: 'Турнир по настольному теннису',
      eventDate: '15.04.2027 в 10:00',
      eventLocation: 'Спортивный комплекс "Олимп"',
      eventCategory: 'Спорт',
    ),
  ];

  @override
  Future<List<NotificationEntity>> getNotifications(String userId) async {
    // Имитация задержки сети
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockNotifications);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _mockNotifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _mockNotifications[index] = _mockNotifications[index].copyWith(
        isRead: true,
      );
    }
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    for (var i = 0; i < _mockNotifications.length; i++) {
      _mockNotifications[i] = _mockNotifications[i].copyWith(isRead: true);
    }
  }
}
