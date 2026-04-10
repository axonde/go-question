import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/settings/domain/entities/app_settings.dart';
import 'package:go_question/features/settings/domain/errors/settings_failures.dart';
import 'package:go_question/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:go_question/features/settings/presentation/bloc/settings_bloc.dart';

class FakeSettingsRepository implements ISettingsRepository {
  Result<AppSettings, SettingsFailure>? loadResult;
  Result<AppSettings, SettingsFailure>? saveResult;
  AppSettings? lastSavedSettings;

  @override
  Future<Result<AppSettings, SettingsFailure>> loadSettings() async {
    return loadResult!;
  }

  @override
  Future<Result<AppSettings, SettingsFailure>> saveSettings(
    AppSettings settings,
  ) async {
    lastSavedSettings = settings;
    return saveResult!;
  }
}

void main() {
  late FakeSettingsRepository repository;
  late SettingsBloc bloc;

  const loadedSettings = AppSettings(
    notificationsEnabled: false,
    hintsEnabled: true,
    compactModeEnabled: true,
  );

  setUp(() {
    repository = FakeSettingsRepository();
    bloc = SettingsBloc(repository);
  });

  tearDown(() async {
    await bloc.close();
  });

  test('emits loading then ready when settings load succeeds', () async {
    repository.loadResult = const Success(loadedSettings);

    final states = <SettingsState>[];
    final subscription = bloc.stream.listen(states.add);

    bloc.add(const SettingsRequested());
    await Future.delayed(Duration.zero);

    expect(states.length, 2);
    expect(states[0].status, SettingsStatus.loading);
    expect(states[1].status, SettingsStatus.ready);
    expect(states[1].settings.notificationsEnabled, false);
    expect(states[1].settings.hintsEnabled, true);
    expect(states[1].settings.compactModeEnabled, true);

    await subscription.cancel();
  });

  test('emits loading then failure when settings load fails', () async {
    repository.loadResult = const Failure(
      SettingsFailure(SettingsFailureType.loadFailed),
    );

    final states = <SettingsState>[];
    final subscription = bloc.stream.listen(states.add);

    bloc.add(const SettingsRequested());
    await Future.delayed(Duration.zero);

    expect(states.length, 2);
    expect(states[0].status, SettingsStatus.loading);
    expect(states[1].status, SettingsStatus.failure);
    expect(states[1].errorMessage, 'Не удалось загрузить настройки');

    await subscription.cancel();
  });

  test('saves updated notifications setting on toggle success', () async {
    repository.loadResult = const Success(loadedSettings);
    repository.saveResult = const Success(
      AppSettings(
        notificationsEnabled: true,
        hintsEnabled: true,
        compactModeEnabled: true,
      ),
    );

    final states = <SettingsState>[];
    final subscription = bloc.stream.listen(states.add);

    bloc.add(const SettingsRequested());
    await Future.delayed(Duration.zero);

    bloc.add(const SettingsNotificationsToggled(true));
    await Future.delayed(Duration.zero);

    expect(repository.lastSavedSettings, isNotNull);
    expect(repository.lastSavedSettings!.notificationsEnabled, true);
    expect(repository.lastSavedSettings!.hintsEnabled, true);
    expect(repository.lastSavedSettings!.compactModeEnabled, true);

    expect(states.last.status, SettingsStatus.ready);
    expect(states.last.settings.notificationsEnabled, true);

    await subscription.cancel();
  });

  test('rolls back settings when toggle save fails', () async {
    repository.loadResult = const Success(loadedSettings);
    repository.saveResult = const Failure(
      SettingsFailure(SettingsFailureType.saveFailed),
    );

    final states = <SettingsState>[];
    final subscription = bloc.stream.listen(states.add);

    bloc.add(const SettingsRequested());
    await Future.delayed(Duration.zero);

    bloc.add(const SettingsNotificationsToggled(true));
    await Future.delayed(Duration.zero);

    expect(states.length, 4);
    expect(states[2].status, SettingsStatus.ready);
    expect(states[2].settings.notificationsEnabled, true);

    expect(states[3].status, SettingsStatus.failure);
    expect(states[3].settings.notificationsEnabled, false);
    expect(states[3].errorMessage, 'Не удалось сохранить настройки');

    await subscription.cancel();
  });

  test('saves selected language when language is changed', () async {
    repository.loadResult = const Success(loadedSettings);
    repository.saveResult = const Success(
      AppSettings(
        notificationsEnabled: false,
        hintsEnabled: true,
        compactModeEnabled: true,
        selectedLanguageCode: 'ru',
      ),
    );

    final states = <SettingsState>[];
    final subscription = bloc.stream.listen(states.add);

    bloc.add(const SettingsRequested());
    await Future.delayed(Duration.zero);

    bloc.add(const SettingsLanguageChanged('ru'));
    await Future.delayed(Duration.zero);

    expect(repository.lastSavedSettings, isNotNull);
    expect(repository.lastSavedSettings!.selectedLanguageCode, 'ru');
    expect(states.last.settings.selectedLanguageCode, 'ru');

    await subscription.cancel();
  });
}
