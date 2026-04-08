import '../../../../core/types/result.dart';
import '../../../../core/utils/profile_firestore_exception_mapper.dart';
import '../../constants/profile_firestore.dart';
import '../../domain/entities/profile.dart';
import '../../domain/errors/profile_exception_to_failure_mapper.dart';
import '../../domain/errors/profile_failure.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../source/profile_remote_datasource.dart';

/// Repository implementation for Profile feature.
///
/// **Responsibilities:**
/// 1. Delegates to datasource (Firestore operations)
/// 2. Maps domain entities ↔ DTOs
/// 3. Catches datasource exceptions → maps to typed failures
/// 4. Returns Result with Profile on success, ProfileFailure on error
///
/// **Error flow:**
/// Datasource throws (AppException | ProfileValidationException)
///   → caught & mapped via ProfileExceptionToFailureMapper
///   → wrapped in Failure with ProfileFailure
///   → returned to use case/presentation
class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileRemoteDataSource _remoteDataSource;
  final ProfileExceptionToFailureMapper _errorMapper;

  const ProfileRepositoryImpl(this._remoteDataSource, this._errorMapper);

  @override
  Future<Result<Profile, ProfileFailure>> getProfile(String uid) async {
    try {
      final modelOrNull = await _remoteDataSource.getProfile(uid);

      if (modelOrNull == null) {
        return Failure(
          ProfileFailure(
            ProfileFailureType.profileNotFound,
            message: '${ProfileFailureMessages.profileNotFoundForUid} $uid',
          ),
        );
      }

      final profile = modelOrNull.toEntity();
      profile.validate(); // Ensure entity invariants
      return Success(profile);
    } catch (error) {
      if (error is ArgumentError) {
        return Failure(
          ProfileFailure(
            ProfileFailureType.invalidName,
            message: error.message?.toString() ?? error.toString(),
          ),
        );
      }

      final mappedException = mapProfileFirestoreException(error);
      final failure = _errorMapper.map(mappedException);
      return Failure(failure);
    }
  }

  @override
  Future<Result<Profile, ProfileFailure>> createInitialProfile({
    required String uid,
    required String initialEmail,
    required String initialName,
    required String initialNickname,
  }) async {
    try {
      final normalizedName = initialName.trim();
      final normalizedEmail = initialEmail.trim();
      final normalizedNickname = initialNickname.trim();

      final initialProfile = Profile(
        uid: uid,
        email: normalizedEmail,
        name: normalizedName,
        nickname: normalizedNickname,
      );
      initialProfile.validate();

      await _remoteDataSource.createInitialProfile(
        uid: uid,
        email: initialProfile.email,
        name: initialProfile.name,
        nickname: initialProfile.nickname,
      );

      // Fetch the created profile to return
      final modelOrNull = await _remoteDataSource.getProfile(uid);
      if (modelOrNull == null) {
        // Should not happen if creation succeeded, but guard against race
        return const Failure(
          ProfileFailure(
            ProfileFailureType.unknown,
            message: ProfileFailureMessages.profileCreatedButNotFoundOnReadBack,
          ),
        );
      }

      final profile = modelOrNull.toEntity();
      profile.validate();
      return Success(profile);
    } catch (error) {
      if (error is ArgumentError) {
        return Failure(
          ProfileFailure(
            ProfileFailureType.invalidName,
            message: error.message?.toString() ?? error.toString(),
          ),
        );
      }

      final mappedException = mapProfileFirestoreException(error);
      final failure = _errorMapper.map(mappedException);
      return Failure(failure);
    }
  }

  @override
  Future<Result<Profile, ProfileFailure>> updateProfile(Profile profile) async {
    try {
      profile.validate(); // Enforce invariants before update

      final currentProfileModel = await _remoteDataSource.getProfile(
        profile.uid,
      );
      if (currentProfileModel != null) {
        final currentProfile = currentProfileModel.toEntity();
        if (currentProfile.nickname != profile.nickname) {
          return const Failure(
            ProfileFailure(
              ProfileFailureType.invalidName,
              message: ProfileFailureMessages.nicknameIsImmutable,
            ),
          );
        }
      }

      await _remoteDataSource.updateProfileBasics(
        uid: profile.uid,
        email: profile.email,
        name: profile.name,
        birthDate: profile.birthDate,
        city: profile.city,
        trophies: profile.trophies,
      );

      // Return updated profile
      return Success(profile);
    } catch (error) {
      if (error is ArgumentError) {
        return Failure(
          ProfileFailure(
            ProfileFailureType.invalidName,
            message: error.message?.toString() ?? error.toString(),
          ),
        );
      }

      final mappedException = mapProfileFirestoreException(error);
      final failure = _errorMapper.map(mappedException);
      return Failure(failure);
    }
  }

  @override
  Future<Result<Profile, ProfileFailure>> incrementVisitedEventsCount(
    String uid,
  ) async {
    if (uid.trim().isEmpty) {
      return const Failure(
        ProfileFailure(
          ProfileFailureType.invalidName,
          message: ProfileValidationMessages.uidCannotBeEmpty,
        ),
      );
    }

    try {
      await _remoteDataSource.incrementVisitedEvents(uid);

      // Fetch updated profile
      final modelOrNull = await _remoteDataSource.getProfile(uid);
      if (modelOrNull == null) {
        return Failure(
          ProfileFailure(
            ProfileFailureType.profileNotFound,
            message:
                '${ProfileFailureMessages.profileNotFoundAfterIncrement} $uid',
          ),
        );
      }

      final profile = modelOrNull.toEntity();
      profile.validate();
      return Success(profile);
    } catch (error) {
      if (error is ArgumentError) {
        return Failure(
          ProfileFailure(
            ProfileFailureType.invalidName,
            message: error.message?.toString() ?? error.toString(),
          ),
        );
      }

      final mappedException = mapProfileFirestoreException(error);
      final failure = _errorMapper.map(mappedException);
      return Failure(failure);
    }
  }

  @override
  Future<Result<Profile, ProfileFailure>> incrementCreatedEventsCount(
    String uid,
  ) async {
    if (uid.trim().isEmpty) {
      return const Failure(
        ProfileFailure(
          ProfileFailureType.invalidName,
          message: ProfileValidationMessages.uidCannotBeEmpty,
        ),
      );
    }

    try {
      await _remoteDataSource.incrementCreatedEvents(uid);

      // Fetch updated profile
      final modelOrNull = await _remoteDataSource.getProfile(uid);
      if (modelOrNull == null) {
        return Failure(
          ProfileFailure(
            ProfileFailureType.profileNotFound,
            message:
                '${ProfileFailureMessages.profileNotFoundAfterIncrement} $uid',
          ),
        );
      }

      final profile = modelOrNull.toEntity();
      profile.validate();
      return Success(profile);
    } catch (error) {
      if (error is ArgumentError) {
        return Failure(
          ProfileFailure(
            ProfileFailureType.invalidName,
            message: error.message?.toString() ?? error.toString(),
          ),
        );
      }

      final mappedException = mapProfileFirestoreException(error);
      final failure = _errorMapper.map(mappedException);
      return Failure(failure);
    }
  }
}
