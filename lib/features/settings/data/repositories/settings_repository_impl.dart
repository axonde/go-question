import 'dart:convert';

import 'package:go_question/core/types/result.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/errors/settings_exception_to_failure_mapper.dart';
import '../../domain/errors/settings_exceptions.dart';
import '../../domain/errors/settings_failures.dart';
import '../../domain/repositories/i_settings_repository.dart';
import '../source/settings_local_data_source.dart';

final class SettingsRepositoryImpl implements ISettingsRepository {
  final SettingsLocalDataSource _localDataSource;
  final SettingsExceptionToFailureMapper _exceptionMapper;

  const SettingsRepositoryImpl(this._localDataSource, this._exceptionMapper);

  @override
  Future<Result<AppSettings, SettingsFailure>> loadSettings() async {
    try {
      final settingsJson = _localDataSource.loadSettingsJson();

      if (settingsJson == null || settingsJson.isEmpty) {
        return const Success(AppSettings.defaults());
      }

      final decoded = jsonDecode(settingsJson);
      if (decoded is! Map<String, dynamic>) {
        throw const SettingsDeserializationException();
      }

      return Success(AppSettings.fromJsonMap(decoded));
    } catch (error) {
      return Failure(_exceptionMapper.map(error));
    }
  }

  @override
  Future<Result<AppSettings, SettingsFailure>> saveSettings(
    AppSettings settings,
  ) async {
    try {
      final settingsJson = jsonEncode(settings.toJsonMap());
      await _localDataSource.saveSettingsJson(settingsJson);
      return Success(settings);
    } catch (error) {
      return Failure(_exceptionMapper.map(error));
    }
  }
}
