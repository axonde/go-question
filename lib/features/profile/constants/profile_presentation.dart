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
}
