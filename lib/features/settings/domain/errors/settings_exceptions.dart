import 'package:go_question/core/errors/exception.dart';

enum SettingsExceptionType { saveFailed, loadFailed, deserializationFailed }

abstract class SettingsException implements AppException {
  SettingsExceptionType get settingsType;
}

final class SettingsSaveException extends BaseAppException
    implements SettingsException {
  @override
  final SettingsExceptionType settingsType = SettingsExceptionType.saveFailed;

  const SettingsSaveException() : super(type: AppExceptionType.cache);
}

final class SettingsLoadException extends BaseAppException
    implements SettingsException {
  @override
  final SettingsExceptionType settingsType = SettingsExceptionType.loadFailed;

  const SettingsLoadException() : super(type: AppExceptionType.cache);
}

final class SettingsDeserializationException extends BaseAppException
    implements SettingsException {
  @override
  final SettingsExceptionType settingsType =
      SettingsExceptionType.deserializationFailed;

  const SettingsDeserializationException()
    : super(type: AppExceptionType.serialization);
}
