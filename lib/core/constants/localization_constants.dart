class LocalizationConstants {
  static const defaultLanguageCode = 'en';
  static const russianLanguageCode = 'ru';

  static const supportedLanguageCodes = <String>[
    defaultLanguageCode,
    russianLanguageCode,
  ];

  static const languagePreferenceJsonKey = 'selectedLanguageCode';

  const LocalizationConstants._();
}
