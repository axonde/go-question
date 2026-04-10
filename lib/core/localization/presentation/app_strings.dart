import 'dart:ui';

import 'package:go_question/core/constants/localization_constants.dart';

class AppStrings {
  final String languageCode;

  const AppStrings._(this.languageCode);

  factory AppStrings.fromLanguageCode(String code) {
    final normalized = code.trim().toLowerCase();
    if (LocalizationConstants.supportedLanguageCodes.contains(normalized)) {
      return AppStrings._(normalized);
    }

    return const AppStrings._(LocalizationConstants.defaultLanguageCode);
  }

  static String resolveLanguageCode({
    required String? selectedLanguageCode,
    required Locale systemLocale,
  }) {
    if (selectedLanguageCode != null) {
      return AppStrings.fromLanguageCode(selectedLanguageCode).languageCode;
    }

    final systemCode = systemLocale.languageCode.trim().toLowerCase();
    if (LocalizationConstants.supportedLanguageCodes.contains(systemCode)) {
      return systemCode;
    }

    return LocalizationConstants.defaultLanguageCode;
  }

  static const Map<String, Map<String, String>> _values = {
    LocalizationConstants.defaultLanguageCode: {
      'app.title': 'Go Question',
      'settings.pageTitle': 'Settings',
      'settings.preferencesTitle': 'App preferences',
      'settings.preferencesHint':
          'These toggles affect only local behavior on this device.',
      'settings.notificationsTitle': 'Notifications',
      'settings.notificationsSubtitle':
          'Show system updates about events and friends.',
      'settings.hintsTitle': 'Interface hints',
      'settings.hintsSubtitle': 'Show helper text and contextual explanations.',
      'settings.compactModeTitle': 'Compact mode',
      'settings.compactModeSubtitle':
          'Use denser layout with reduced vertical spacing.',
      'settings.soundTitle': 'Sound',
      'settings.soundSubtitle': 'Enable music and interface sounds.',
      'settings.accountTitle': 'Account',
      'settings.signOut': 'Sign out',
      'settings.signIn': 'Sign in',
      'settings.languageTitle': 'Language',
      'settings.languageSubtitle': 'Select interface language.',
      'settings.languageSystem': 'System default',
      'settings.languageEnglish': 'English',
      'settings.languageRussian': 'Russian',
      'nav.friends': 'Friends',
      'nav.home': 'Go',
      'nav.settings': 'Settings',
      'home.actionSearch': 'Search',
      'home.actionNew': 'New',
      'home.notificationsButton': 'Notifications',
      'home.citySelectorTitle': 'Select city',
      'home.snackEventCreated': 'Event created',
      'home.snackNewNotificationPrefix': 'New notification:',
      'home.profileLoginAction': 'Sign in',
      'home.profileAccessHint': 'Sign in to access profile',
      'home.profileMaxScore': 'max.',
      'notifications.headerTitle': 'Notifications',
      'notifications.tapHint': 'Tap a notification to see details.',
      'notifications.emptyState': 'No notifications yet',
      'notifications.unreadSectionTitle': 'Unread',
      'notifications.readSectionTitle': 'Read',
      'notifications.snackReadCleared': 'Read notifications were cleared',
      'notifications.buttonApprove': 'Approve',
      'notifications.buttonReject': 'Reject',
      'notifications.ratingPrefix': 'Rating',
      'notifications.visitedLabel': 'Visited',
      'notifications.organizedLabel': 'Organized',
      'notifications.aboutLabel': 'About me',
      'notifications.titleFriendRequest': 'Friend request',
      'notifications.titleJoinRequest': 'Join request',
      'notifications.titleEventReminder': 'Event reminder',
      'notifications.titleMessage': 'New message',
      'notifications.titleSystem': 'System message',
      'notifications.bodyFriendRequest':
          'User {user} sent you a friend request.',
      'notifications.bodyJoinRequest':
          'User {user} requested to join event {event}.',
      'notifications.bodyEventReminder': 'Event {event} starts soon.',
      'notifications.bodyMessage': 'You have a new message.',
      'notifications.bodySystem': 'System update.',
      'achievements.dialogTitle': 'Achievements',
      'achievements.loadError': 'Failed to load achievements',
      'leaderboard.title': 'Top players',
      'leaderboard.empty': 'No players with trophies yet.',
      'city.moscow': 'Moscow',
      'city.saintPetersburg': 'Saint Petersburg',
      'city.kazan': 'Kazan',
      'city.ekaterinburg': 'Yekaterinburg',
      'city.novosibirsk': 'Novosibirsk',
      'city.nizhnyNovgorod': 'Nizhny Novgorod',
      'city.krasnodar': 'Krasnodar',
      'city.sochi': 'Sochi',
      'city.other': 'Other city',
      'friends.pageTitle': 'Friends',
      'friends.searchSectionTitle': 'Search user by ID',
      'friends.searchHint': 'Enter user ID',
      'friends.searchEmpty': 'Start typing ID to find a user.',
      'friends.searchNotFound': 'User with this ID was not found.',
      'friends.alreadyFriend': 'Already in your friends',
      'friends.addFriend': 'Add',
      'friends.selfAccount': 'You',
      'friends.friendRequestPending': 'Pending confirmation',
      'friends.friendRequestIncoming': 'Incoming request',
      'friends.friendsSectionTitle': 'My friends',
      'friends.noFriends': 'Your friends list is empty.',
      'friends.noFriendsHint':
          'Add users via search by ID at the top of the screen.',
      'friends.openProfileStubTitle': 'User profile',
      'friends.openProfileStubDescription':
          'We will open this user profile here in the next step.',
      'friends.friendCountLabel': 'friends',
      'friends.friendIdPrefix': 'ID',
      'friends.cityPrefix': 'City',
      'friends.levelPrefix': 'Level',
      'friends.friendCityFallback': 'Not specified',
    },
    LocalizationConstants.russianLanguageCode: {
      'app.title': 'Go Question',
      'settings.pageTitle': 'Настройки',
      'settings.preferencesTitle': 'Параметры приложения',
      'settings.preferencesHint':
          'Эти переключатели работают локально на этом устройстве.',
      'settings.notificationsTitle': 'Уведомления',
      'settings.notificationsSubtitle':
          'Показывать системные обновления о событиях и друзьях.',
      'settings.hintsTitle': 'Подсказки в интерфейсе',
      'settings.hintsSubtitle':
          'Показывать поясняющие тексты и подсказки на экранах.',
      'settings.compactModeTitle': 'Компактный режим',
      'settings.compactModeSubtitle':
          'Сделать интерфейс плотнее и уменьшить вертикальные отступы.',
      'settings.soundTitle': 'Звук',
      'settings.soundSubtitle': 'Включать музыку и звуки интерфейса.',
      'settings.accountTitle': 'Аккаунт',
      'settings.signOut': 'Выйти',
      'settings.signIn': 'Войти',
      'settings.languageTitle': 'Язык',
      'settings.languageSubtitle': 'Выберите язык интерфейса.',
      'settings.languageSystem': 'Системный',
      'settings.languageEnglish': 'Английский',
      'settings.languageRussian': 'Русский',
      'nav.friends': 'Друзья',
      'nav.home': 'Го',
      'nav.settings': 'Настройки',
      'home.actionSearch': 'Поиск',
      'home.actionNew': 'Новое',
      'home.notificationsButton': 'Уведомления',
      'home.citySelectorTitle': 'Выбор города',
      'home.snackEventCreated': 'Ивент создан',
      'home.snackNewNotificationPrefix': 'Новое уведомление:',
      'home.profileLoginAction': 'Войти',
      'home.profileAccessHint': 'Для доступа к профилю',
      'home.profileMaxScore': 'макс.',
      'notifications.headerTitle': 'Уведомления',
      'notifications.tapHint': 'Нажмите на уведомление, чтобы узнать детали.',
      'notifications.emptyState': 'Уведомлений пока нет',
      'notifications.unreadSectionTitle': 'Непрочитанные',
      'notifications.readSectionTitle': 'Прочитанные',
      'notifications.snackReadCleared': 'Прочитанные уведомления очищены',
      'notifications.buttonApprove': 'Принять',
      'notifications.buttonReject': 'Отклонить',
      'notifications.ratingPrefix': 'Рейтинг',
      'notifications.visitedLabel': 'Посетил',
      'notifications.organizedLabel': 'Организовал',
      'notifications.aboutLabel': 'О себе',
      'notifications.titleFriendRequest': 'Заявка в друзья',
      'notifications.titleJoinRequest': 'Заявка на участие',
      'notifications.titleEventReminder': 'Напоминание о событии',
      'notifications.titleMessage': 'Новое сообщение',
      'notifications.titleSystem': 'Системное сообщение',
      'notifications.bodyFriendRequest':
          'Пользователь {user} отправил вам заявку в друзья.',
      'notifications.bodyJoinRequest':
          'Пользователь {user} запросил участие в событии {event}.',
      'notifications.bodyEventReminder': 'Событие {event} скоро начнется.',
      'notifications.bodyMessage': 'У вас новое сообщение.',
      'notifications.bodySystem': 'Системное обновление.',
      'achievements.dialogTitle': 'Достижения',
      'achievements.loadError': 'Не удалось загрузить достижения',
      'leaderboard.title': 'Топ игроков',
      'leaderboard.empty': 'Пока нет игроков с кубками.',
      'city.moscow': 'Москва',
      'city.saintPetersburg': 'Санкт-Петербург',
      'city.kazan': 'Казань',
      'city.ekaterinburg': 'Екатеринбург',
      'city.novosibirsk': 'Новосибирск',
      'city.nizhnyNovgorod': 'Нижний Новгород',
      'city.krasnodar': 'Краснодар',
      'city.sochi': 'Сочи',
      'city.other': 'Другой город',
      'friends.pageTitle': 'Друзья',
      'friends.searchSectionTitle': 'Поиск пользователя по ID',
      'friends.searchHint': 'Введите ID пользователя',
      'friends.searchEmpty': 'Начните вводить ID, чтобы найти пользователя.',
      'friends.searchNotFound': 'Пользователь с таким ID не найден.',
      'friends.alreadyFriend': 'Этот пользователь уже у вас в друзьях.',
      'friends.addFriend': 'Добавить',
      'friends.selfAccount': 'Это вы',
      'friends.friendRequestPending': 'Ожидает подтверждения',
      'friends.friendRequestIncoming': 'Входящая заявка',
      'friends.friendsSectionTitle': 'Мои друзья',
      'friends.noFriends': 'Список друзей пока пуст.',
      'friends.noFriendsHint':
          'Добавьте пользователя через поиск по ID в верхней части экрана.',
      'friends.openProfileStubTitle': 'Профиль пользователя',
      'friends.openProfileStubDescription':
          'Экран профиля этого пользователя откроем здесь на следующем этапе.',
      'friends.friendCountLabel': 'друзей',
      'friends.friendIdPrefix': 'ID',
      'friends.cityPrefix': 'Город',
      'friends.levelPrefix': 'Уровень',
      'friends.friendCityFallback': 'Не указан',
    },
  };

  String value(String key) {
    final localized = _values[languageCode]?[key];
    if (localized != null) {
      return localized;
    }

    final fallback = _values[LocalizationConstants.defaultLanguageCode]?[key];
    return fallback ?? key;
  }

  String get appTitle => value('app.title');

  String get settingsPageTitle => value('settings.pageTitle');
  String get settingsPreferencesTitle => value('settings.preferencesTitle');
  String get settingsPreferencesHint => value('settings.preferencesHint');
  String get settingsNotificationsTitle => value('settings.notificationsTitle');
  String get settingsNotificationsSubtitle =>
      value('settings.notificationsSubtitle');
  String get settingsHintsTitle => value('settings.hintsTitle');
  String get settingsHintsSubtitle => value('settings.hintsSubtitle');
  String get settingsCompactModeTitle => value('settings.compactModeTitle');
  String get settingsCompactModeSubtitle =>
      value('settings.compactModeSubtitle');
  String get settingsSoundTitle => value('settings.soundTitle');
  String get settingsSoundSubtitle => value('settings.soundSubtitle');
  String get settingsAccountTitle => value('settings.accountTitle');
  String get settingsSignOut => value('settings.signOut');
  String get settingsSignIn => value('settings.signIn');
  String get settingsLanguageTitle => value('settings.languageTitle');
  String get settingsLanguageSubtitle => value('settings.languageSubtitle');
  String get settingsLanguageSystem => value('settings.languageSystem');
  String get settingsLanguageEnglish => value('settings.languageEnglish');
  String get settingsLanguageRussian => value('settings.languageRussian');

  String get navFriends => value('nav.friends');
  String get navHome => value('nav.home');
  String get navSettings => value('nav.settings');

  String get homeActionSearch => value('home.actionSearch');
  String get homeActionNew => value('home.actionNew');
  String get homeNotificationsButton => value('home.notificationsButton');
  String get homeCitySelectorTitle => value('home.citySelectorTitle');
  String get homeSnackEventCreated => value('home.snackEventCreated');
  String get homeSnackNewNotificationPrefix =>
      value('home.snackNewNotificationPrefix');
  String get homeProfileLoginAction => value('home.profileLoginAction');
  String get homeProfileAccessHint => value('home.profileAccessHint');
  String get homeProfileMaxScore => value('home.profileMaxScore');

  String get notificationsHeaderTitle => value('notifications.headerTitle');
  String get notificationsTapHint => value('notifications.tapHint');
  String get notificationsEmptyState => value('notifications.emptyState');
  String get notificationsUnreadSectionTitle =>
      value('notifications.unreadSectionTitle');
  String get notificationsReadSectionTitle =>
      value('notifications.readSectionTitle');
  String get notificationsSnackReadCleared =>
      value('notifications.snackReadCleared');
  String get notificationsButtonApprove => value('notifications.buttonApprove');
  String get notificationsButtonReject => value('notifications.buttonReject');
  String get notificationsRatingPrefix => value('notifications.ratingPrefix');
  String get notificationsVisitedLabel => value('notifications.visitedLabel');
  String get notificationsOrganizedLabel =>
      value('notifications.organizedLabel');
  String get notificationsAboutLabel => value('notifications.aboutLabel');
  String get notificationsTitleFriendRequest =>
      value('notifications.titleFriendRequest');
  String get notificationsTitleJoinRequest =>
      value('notifications.titleJoinRequest');
  String get notificationsTitleEventReminder =>
      value('notifications.titleEventReminder');
  String get notificationsTitleMessage => value('notifications.titleMessage');
  String get notificationsTitleSystem => value('notifications.titleSystem');
  String notificationsBodyFriendRequest({required String user}) =>
      _format(value('notifications.bodyFriendRequest'), {'user': user});
  String notificationsBodyJoinRequest({
    required String user,
    required String event,
  }) => _format(value('notifications.bodyJoinRequest'), {
    'user': user,
    'event': event,
  });
  String notificationsBodyEventReminder({required String event}) =>
      _format(value('notifications.bodyEventReminder'), {'event': event});
  String get notificationsBodyMessage => value('notifications.bodyMessage');
  String get notificationsBodySystem => value('notifications.bodySystem');

  String get achievementsDialogTitle => value('achievements.dialogTitle');
  String get achievementsLoadError => value('achievements.loadError');

  String get leaderboardTitle => value('leaderboard.title');
  String get leaderboardEmpty => value('leaderboard.empty');

  String cityLabel(String cityKey) => value(cityKey);

  String get friendsPageTitle => value('friends.pageTitle');
  String get friendsSearchSectionTitle => value('friends.searchSectionTitle');
  String get friendsSearchHint => value('friends.searchHint');
  String get friendsSearchEmpty => value('friends.searchEmpty');
  String get friendsSearchNotFound => value('friends.searchNotFound');
  String get friendsAlreadyFriend => value('friends.alreadyFriend');
  String get friendsAddFriend => value('friends.addFriend');
  String get friendsSelfAccount => value('friends.selfAccount');
  String get friendsRequestPending => value('friends.friendRequestPending');
  String get friendsRequestIncoming => value('friends.friendRequestIncoming');
  String get friendsSectionTitle => value('friends.friendsSectionTitle');
  String get friendsNoFriends => value('friends.noFriends');
  String get friendsNoFriendsHint => value('friends.noFriendsHint');
  String get friendsOpenProfileStubTitle =>
      value('friends.openProfileStubTitle');
  String get friendsOpenProfileStubDescription =>
      value('friends.openProfileStubDescription');
  String get friendsCountLabel => value('friends.friendCountLabel');
  String get friendsIdPrefix => value('friends.friendIdPrefix');
  String get friendsCityPrefix => value('friends.cityPrefix');
  String get friendsLevelPrefix => value('friends.levelPrefix');
  String get friendsCityFallback => value('friends.friendCityFallback');

  String _format(String template, Map<String, String> params) {
    var result = template;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }
}
