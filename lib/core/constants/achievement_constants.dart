abstract final class AchievementConstants {
  static const String firstOpenAchievements = 'first_open_achievements';
  static const String firstCreatedEvent = 'first_created_event';
  static const String firstJoinedEvent = 'first_joined_event';

  static const List<String> allIds = <String>[
    firstOpenAchievements,
    firstCreatedEvent,
    firstJoinedEvent,
  ];

  static const Map<String, String> titles = <String, String>{
    firstOpenAchievements: 'Первый шаг',
    firstCreatedEvent: 'Организатор',
    firstJoinedEvent: 'Участник',
  };

  static const Map<String, String> descriptions = <String, String>{
    firstOpenAchievements: 'Откройте окно достижений впервые.',
    firstCreatedEvent: 'Создайте свой первый ивент.',
    firstJoinedEvent: 'Запишитесь на ивент впервые.',
  };

  const AchievementConstants._();
}
