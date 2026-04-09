import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/core/constants/settings_constants.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:go_question/features/settings/data/source/settings_local_data_source.dart';
import 'package:go_question/features/settings/domain/entities/app_settings.dart';
import 'package:go_question/features/settings/domain/errors/settings_exception_to_failure_mapper.dart';
import 'package:go_question/features/settings/domain/errors/settings_failures.dart';

class FakeSettingsLocalDataSource implements SettingsLocalDataSource {
  String? storedJson;
  bool shouldThrowOnLoad = false;
  bool shouldThrowOnSave = false;

  @override
  String? loadSettingsJson() {
    if (shouldThrowOnLoad) {
      throw Exception('load failed');
    }

    return storedJson;
  }

  @override
  Future<void> saveSettingsJson(String settingsJson) async {
    if (shouldThrowOnSave) {
      throw Exception('save failed');
    }

    storedJson = settingsJson;
  }
}

void main() {
  late FakeSettingsLocalDataSource dataSource;
  late SettingsRepositoryImpl repository;

  setUp(() {
    dataSource = FakeSettingsLocalDataSource();
    repository = SettingsRepositoryImpl(
      dataSource,
      const SettingsExceptionToFailureMapperImpl(),
    );
  });

  test(
    'saveSettings stores settings in one json string and returns success',
    () async {
      const settings = AppSettings(
        notificationsEnabled: false,
        hintsEnabled: true,
        compactModeEnabled: true,
      );

      final result = await repository.saveSettings(settings);

      expect(result, isA<Success<AppSettings, SettingsFailure>>());
      expect(
        dataSource.storedJson,
        jsonEncode({
          SettingsConstants.notificationsJsonKey: false,
          SettingsConstants.hintsJsonKey: true,
          SettingsConstants.compactModeJsonKey: true,
        }),
      );
    },
  );

  test('loadSettings restores settings from stored json string', () async {
    dataSource.storedJson = jsonEncode({
      SettingsConstants.notificationsJsonKey: true,
      SettingsConstants.hintsJsonKey: false,
      SettingsConstants.compactModeJsonKey: true,
    });

    final result = await repository.loadSettings();

    result.fold(
      onSuccess: (settings) {
        expect(settings.notificationsEnabled, true);
        expect(settings.hintsEnabled, false);
        expect(settings.compactModeEnabled, true);
      },
      onFailure: (_) {
        fail('Expected loadSettings to succeed');
      },
    );
  });

  test('loadSettings returns default values when nothing is stored', () async {
    final result = await repository.loadSettings();

    result.fold(
      onSuccess: (settings) {
        expect(
          settings.notificationsEnabled,
          SettingsConstants.defaultNotificationsEnabled,
        );
        expect(settings.hintsEnabled, SettingsConstants.defaultHintsEnabled);
        expect(
          settings.compactModeEnabled,
          SettingsConstants.defaultCompactModeEnabled,
        );
      },
      onFailure: (_) {
        fail('Expected loadSettings to return defaults');
      },
    );
  });
}
