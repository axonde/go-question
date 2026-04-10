import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/core/types/result.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/errors/settings_failures.dart';
import '../../domain/repositories/i_settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ISettingsRepository _settingsRepository;

  SettingsBloc(this._settingsRepository)
    : super(const SettingsState.initial()) {
    on<SettingsRequested>(_onSettingsRequested);
    on<SettingsNotificationsToggled>(_onNotificationsToggled);
    on<SettingsHintsToggled>(_onHintsToggled);
    on<SettingsCompactModeToggled>(_onCompactModeToggled);
    on<SettingsLanguageChanged>(_onLanguageChanged);
  }

  Future<void> _onSettingsRequested(
    SettingsRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading, clearError: true));

    final result = await _settingsRepository.loadSettings();
    result.fold(
      onSuccess: (settings) {
        emit(
          state.copyWith(
            status: SettingsStatus.ready,
            settings: settings,
            clearError: true,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: SettingsStatus.failure,
            errorMessage: _mapErrorMessage(failure),
          ),
        );
      },
    );
  }

  Future<void> _onNotificationsToggled(
    SettingsNotificationsToggled event,
    Emitter<SettingsState> emit,
  ) async {
    await _persistUpdatedSettings(
      emit: emit,
      updatedSettings: state.settings.copyWith(
        notificationsEnabled: event.enabled,
      ),
    );
  }

  Future<void> _onHintsToggled(
    SettingsHintsToggled event,
    Emitter<SettingsState> emit,
  ) async {
    await _persistUpdatedSettings(
      emit: emit,
      updatedSettings: state.settings.copyWith(hintsEnabled: event.enabled),
    );
  }

  Future<void> _onCompactModeToggled(
    SettingsCompactModeToggled event,
    Emitter<SettingsState> emit,
  ) async {
    await _persistUpdatedSettings(
      emit: emit,
      updatedSettings: state.settings.copyWith(
        compactModeEnabled: event.enabled,
      ),
    );
  }

  Future<void> _onLanguageChanged(
    SettingsLanguageChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await _persistUpdatedSettings(
      emit: emit,
      updatedSettings: event.languageCode == null
          ? state.settings.copyWith(clearSelectedLanguageCode: true)
          : state.settings.copyWith(selectedLanguageCode: event.languageCode),
    );
  }

  Future<void> _persistUpdatedSettings({
    required Emitter<SettingsState> emit,
    required AppSettings updatedSettings,
  }) async {
    final previousSettings = state.settings;

    emit(
      state.copyWith(
        status: SettingsStatus.ready,
        settings: updatedSettings,
        clearError: true,
      ),
    );

    final result = await _settingsRepository.saveSettings(updatedSettings);
    result.fold(
      onSuccess: (savedSettings) {
        emit(
          state.copyWith(
            status: SettingsStatus.ready,
            settings: savedSettings,
            clearError: true,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: SettingsStatus.failure,
            settings: previousSettings,
            errorMessage: _mapErrorMessage(failure),
          ),
        );
      },
    );
  }

  String _mapErrorMessage(SettingsFailure failure) {
    return switch (failure.type) {
      SettingsFailureType.saveFailed => 'Не удалось сохранить настройки',
      SettingsFailureType.loadFailed => 'Не удалось загрузить настройки',
      SettingsFailureType.invalidStoredData =>
        'Сохраненные настройки повреждены',
      SettingsFailureType.unknown => 'Произошла ошибка в настройках',
    };
  }
}
