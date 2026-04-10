import 'package:go_question/core/constants/settings_constants.dart';

class AppSettings {
  final bool notificationsEnabled;
  final bool hintsEnabled;
  final bool compactModeEnabled;
  final String? selectedLanguageCode;

  const AppSettings({
    required this.notificationsEnabled,
    required this.hintsEnabled,
    required this.compactModeEnabled,
    this.selectedLanguageCode,
  });

  const AppSettings.defaults()
    : notificationsEnabled = SettingsConstants.defaultNotificationsEnabled,
      hintsEnabled = SettingsConstants.defaultHintsEnabled,
      compactModeEnabled = SettingsConstants.defaultCompactModeEnabled,
      selectedLanguageCode = null;

  Map<String, dynamic> toJsonMap() {
    return {
      SettingsConstants.notificationsJsonKey: notificationsEnabled,
      SettingsConstants.hintsJsonKey: hintsEnabled,
      SettingsConstants.compactModeJsonKey: compactModeEnabled,
      SettingsConstants.languageJsonKey: selectedLanguageCode,
    };
  }

  factory AppSettings.fromJsonMap(Map<String, dynamic> map) {
    return AppSettings(
      notificationsEnabled:
          map[SettingsConstants.notificationsJsonKey] as bool? ??
          SettingsConstants.defaultNotificationsEnabled,
      hintsEnabled:
          map[SettingsConstants.hintsJsonKey] as bool? ??
          SettingsConstants.defaultHintsEnabled,
      compactModeEnabled:
          map[SettingsConstants.compactModeJsonKey] as bool? ??
          SettingsConstants.defaultCompactModeEnabled,
      selectedLanguageCode: map[SettingsConstants.languageJsonKey] as String?,
    );
  }

  AppSettings copyWith({
    bool? notificationsEnabled,
    bool? hintsEnabled,
    bool? compactModeEnabled,
    String? selectedLanguageCode,
    bool clearSelectedLanguageCode = false,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      hintsEnabled: hintsEnabled ?? this.hintsEnabled,
      compactModeEnabled: compactModeEnabled ?? this.compactModeEnabled,
      selectedLanguageCode: clearSelectedLanguageCode
          ? null
          : (selectedLanguageCode ?? this.selectedLanguageCode),
    );
  }
}
