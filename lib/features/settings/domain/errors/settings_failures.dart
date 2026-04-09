import 'package:go_question/core/errors/failures.dart' as core;

enum SettingsFailureType { saveFailed, loadFailed, invalidStoredData, unknown }

final class SettingsFailure implements core.Failure<SettingsFailureType> {
  @override
  final SettingsFailureType type;

  @override
  final String message;

  const SettingsFailure(this.type, {this.message = ''});
}
