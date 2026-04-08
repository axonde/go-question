import '../../../../core/errors/exception_to_failure_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../constants/profile_firestore.dart';
import 'profile_exception.dart';
import 'profile_failure.dart';

abstract interface class ProfileExceptionToFailureMapper
    implements ExceptionToFailureMapper<ProfileFailure> {}

final class ProfileExceptionToFailureMapperImpl
    implements ProfileExceptionToFailureMapper {
  final ExceptionToFailureMapper<GlobalFailure> _commonMapper;

  const ProfileExceptionToFailureMapperImpl({
    ExceptionToFailureMapper<GlobalFailure> commonMapper =
        const DefaultExceptionToFailureMapper(),
  }) : _commonMapper = commonMapper;

  @override
  ProfileFailure map(Object error) {
    if (error is ProfileValidationException) {
      return ProfileFailure(
        ProfileFailureType.invalidName, // Could be name, age, or counters
        message: error.violation,
      );
    }
    if (error is ProfileNotFoundException) {
      return ProfileFailure(
        ProfileFailureType.profileNotFound,
        message:
            '${ProfileFailureMessages.profileNotFoundForUidPattern}${error.uid}',
      );
    }

    // Fallback to common mapper
    final commonFailure = _commonMapper.map(error);
    return ProfileFailure(
      _mapCommonFailure(commonFailure.type),
      message: commonFailure.message,
    );
  }

  ProfileFailureType _mapCommonFailure(AppFailureType type) {
    return switch (type) {
      AppFailureType.serverError => ProfileFailureType.server,
      AppFailureType.connectionError => ProfileFailureType.network,
      AppFailureType.validationError => ProfileFailureType.invalidName,
      AppFailureType.unknownError => ProfileFailureType.unknown,
      _ => ProfileFailureType.unknown,
    };
  }
}
