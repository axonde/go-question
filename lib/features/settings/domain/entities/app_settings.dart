import 'package:go_question/core/constants/settings_constants.dart';

class AppSettings {
  final bool notificationsEnabled;
  final bool hintsEnabled;
  final bool compactModeEnabled;

  const AppSettings({
    required this.notificationsEnabled,
    required this.hintsEnabled,
    required this.compactModeEnabled,
  });

  const AppSettings.defaults()
    : notificationsEnabled = SettingsConstants.defaultNotificationsEnabled,
      hintsEnabled = SettingsConstants.defaultHintsEnabled,
      compactModeEnabled = SettingsConstants.defaultCompactModeEnabled;

  Map<String, dynamic> toJsonMap() {
    return {
      SettingsConstants.notificationsJsonKey: notificationsEnabled,
      SettingsConstants.hintsJsonKey: hintsEnabled,
      SettingsConstants.compactModeJsonKey: compactModeEnabled,
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
    );
  }

  AppSettings copyWith({
    bool? notificationsEnabled,
    bool? hintsEnabled,
    bool? compactModeEnabled,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      hintsEnabled: hintsEnabled ?? this.hintsEnabled,
      compactModeEnabled: compactModeEnabled ?? this.compactModeEnabled,
    );
  }
}
