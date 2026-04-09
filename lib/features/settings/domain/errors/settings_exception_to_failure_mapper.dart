import 'package:go_question/core/errors/exception_to_failure_mapper.dart';
import 'package:go_question/core/errors/failures.dart';

import 'settings_exceptions.dart';
import 'settings_failures.dart';

abstract interface class SettingsExceptionToFailureMapper
    implements ExceptionToFailureMapper<SettingsFailure> {}

final class SettingsExceptionToFailureMapperImpl
    implements SettingsExceptionToFailureMapper {
  final ExceptionToFailureMapper<GlobalFailure> _commonMapper;

  const SettingsExceptionToFailureMapperImpl({
    ExceptionToFailureMapper<GlobalFailure> commonMapper =
        const DefaultExceptionToFailureMapper(),
  }) : _commonMapper = commonMapper;

  @override
  SettingsFailure map(Object error) {
    if (error is SettingsSaveException) {
      return const SettingsFailure(SettingsFailureType.saveFailed);
    }

    if (error is SettingsLoadException) {
      return const SettingsFailure(SettingsFailureType.loadFailed);
    }

    if (error is SettingsDeserializationException) {
      return const SettingsFailure(SettingsFailureType.invalidStoredData);
    }

    final commonFailure = _commonMapper.map(error);
    return SettingsFailure(
      _mapCommonFailure(commonFailure.type),
      message: commonFailure.message,
    );
  }

  SettingsFailureType _mapCommonFailure(AppFailureType type) {
    return switch (type) {
      AppFailureType.cacheUpdateError => SettingsFailureType.saveFailed,
      AppFailureType.validationError => SettingsFailureType.invalidStoredData,
      _ => SettingsFailureType.unknown,
    };
  }
}
