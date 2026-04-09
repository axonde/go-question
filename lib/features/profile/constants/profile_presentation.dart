/// UI constants for Profile feature presentation layer.
/// Single source of truth for all hardcoded strings in UI components.
class ProfilePresentationConstants {
  ProfilePresentationConstants._();

  // Asset paths
  static const String backgroundImagePath =
      'assets/images/background/background.webp';
  static const String defaultAvatarPath =
      'assets/images/presets/default_ava.png';

  // Demo data
  static const String demoName = 'Maxim Maximka';
  static const String demoNick = 'papeiko';
  static const String demoYearsOld = '19 лет';
  static const String demoCity = 'Санкт-Петербург';
  static const String demoEmail = 'danil-kolbasenko@gmail.com';

  // UI text
  static const String editHintText =
      'Для редактирования нажмите на выбранное поле';
  static const String dialogTitle = 'Редактировать';
  static const String dialogInputHint = 'Введите значение';
  static const String dialogCancelButton = 'Отмена';
  static const String dialogSaveButton = 'Сохранить';

  static const String completionTitle = 'Заполните профиль';
  static const String completionDescription =
      'Добавьте недостающие данные, чтобы мы могли корректно показать вас другим пользователям.';
  static const String completionSaveButton = 'Сохранить профиль';
  static const String completionCityHint = 'Город';
  static const String completionCityLabel = 'Город';
  static const String completionBioHint = 'Коротко о себе';
  static const String completionGenderHint = 'Пол';
  static const String completionGenderLabel = 'Пол';
  static const String completionAgeHint = 'Возраст';
  static const String completionAgeLabel = 'Возраст';
  static const String completionBirthDateHint = 'Дата рождения';
  static const String completionAvatarHint = 'Аватар из галереи';
  static const String completionOptionalSuffix = 'необязательно';

  static const List<String> completionCityOptions = [
    'Москва',
    'Санкт-Петербург',
    'Казань',
    'Екатеринбург',
    'Новосибирск',
    'Нижний Новгород',
    'Краснодар',
    'Сочи',
    'Другой город',
  ];

  static const List<String> completionGenderOptions = [
    'Мужской',
    'Женский',
    'Другое',
    'Не указывать',
  ];

  static const int completionMinAge = 7;
  static const int completionMaxAge = 99;
}
