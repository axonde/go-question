part of 'settings_bloc.dart';

sealed class SettingsEvent {
  const SettingsEvent();
}

final class SettingsRequested extends SettingsEvent {
  const SettingsRequested();
}

final class SettingsNotificationsToggled extends SettingsEvent {
  final bool enabled;

  const SettingsNotificationsToggled(this.enabled);
}

final class SettingsHintsToggled extends SettingsEvent {
  final bool enabled;

  const SettingsHintsToggled(this.enabled);
}

final class SettingsCompactModeToggled extends SettingsEvent {
  final bool enabled;

  const SettingsCompactModeToggled(this.enabled);
}

final class SettingsLanguageChanged extends SettingsEvent {
  final String? languageCode;

  const SettingsLanguageChanged(this.languageCode);
}
