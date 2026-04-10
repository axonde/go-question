class EventConstants {
  static const organizerEventIds = {'2', '4'};

  static const statusOpen = 'open';
  static const statusUpcoming = 'upcoming';
  static const statusClosed = 'closed';
  static const statuses = [statusOpen, statusUpcoming, statusClosed];
  static const createDialogBorderWidth = 8.0;
  static const createDialogBorderColorValue = 0xFF576278;
  static const createDialogBackgroundAssetPath =
      'assets/images/background/background.webp';

  static const defaultImageUrl = '';
  static const defaultParticipants = 0;
  static const fallbackOrganizerId = 'current-user-id';
  static const visibilityPublic = 'public';
  static const visibilityFriends = 'friends';
  static const visibilityPrivate = 'private';
  static const joinModeOpen = 'open';
  static const joinModeRequest = 'request';
  static const joinModeInvite = 'invite';

  static const List<EventDurationOption> durationOptions = [
    EventDurationOption.minutes30,
    EventDurationOption.hour1,
    EventDurationOption.hour2,
    EventDurationOption.hour3,
    EventDurationOption.hour4,
  ];

  static const monthsLong = [
    '',
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря',
  ];

  static const monthsShort = [
    '',
    'янв',
    'фев',
    'мар',
    'апр',
    'май',
    'июн',
    'июл',
    'авг',
    'сен',
    'окт',
    'ноя',
    'дек',
  ];
}

enum EventDurationOption {
  minutes30(30, '30 минут'),
  hour1(60, '1 час'),
  hour2(120, '2 часа'),
  hour3(180, '3 часа'),
  hour4(240, '4 часа');

  final int minutes;
  final String label;

  const EventDurationOption(this.minutes, this.label);
}
