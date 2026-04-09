part of 'settings_bloc.dart';

enum SettingsStatus { initial, loading, ready, failure }

class SettingsState {
  final SettingsStatus status;
  final AppSettings settings;
  final String? errorMessage;

  const SettingsState({
    required this.status,
    required this.settings,
    this.errorMessage,
  });

  const SettingsState.initial()
    : status = SettingsStatus.initial,
      settings = const AppSettings.defaults(),
      errorMessage = null;

  SettingsState copyWith({
    SettingsStatus? status,
    AppSettings? settings,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
