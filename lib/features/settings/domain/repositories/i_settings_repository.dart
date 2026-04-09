import 'package:go_question/core/types/result.dart';

import '../entities/app_settings.dart';
import '../errors/settings_failures.dart';

abstract interface class ISettingsRepository {
  Future<Result<AppSettings, SettingsFailure>> loadSettings();

  Future<Result<AppSettings, SettingsFailure>> saveSettings(
    AppSettings settings,
  );
}
