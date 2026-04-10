import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/settings_constants.dart';
import '../../domain/errors/settings_exceptions.dart';

abstract interface class SettingsLocalDataSource {
  String? loadSettingsJson();

  Future<void> saveSettingsJson(String settingsJson);
}

final class SharedPrefsSettingsLocalDataSource
    implements SettingsLocalDataSource {
  final SharedPreferences _sharedPreferences;

  const SharedPrefsSettingsLocalDataSource(this._sharedPreferences);

  @override
  String? loadSettingsJson() {
    try {
      return _sharedPreferences.getString(SettingsConstants.storageJsonKey);
    } catch (_) {
      throw const SettingsLoadException();
    }
  }

  @override
  Future<void> saveSettingsJson(String settingsJson) async {
    try {
      final isSaved = await _sharedPreferences.setString(
        SettingsConstants.storageJsonKey,
        settingsJson,
      );

      if (!isSaved) {
        throw const SettingsSaveException();
      }
    } catch (_) {
      throw const SettingsSaveException();
    }
  }
}
