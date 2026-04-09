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
/// Responsibilities:
/// 1. Delegates to datasource (Firestore operations)
/// 2. Maps domain entities ↔ DTOs
/// 3. Catches datasource exceptions → maps to typed failures
/// 4. Returns Result with Profile on success, ProfileFailure on error
/// 5. Keeps an in-memory cache so screen switches do not drop data
class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileRemoteDataSource _remoteDataSource;
  final ProfileExceptionToFailureMapper _errorMapper;

  final Map<String, Profile> _profileCache = {};
  final Map<String, List<Profile>> _friendsCache = {};

  ProfileRepositoryImpl(this._remoteDataSource, this._errorMapper);

  @override
  Future<Result<Profile, ProfileFailure>> getProfile(String uid) async {
    try {
      final modelOrNull = await _remoteDataSource.getProfile(uid);

      if (modelOrNull == null) {
        final cached = _profileCache[uid];
        if (cached != null) {
          return Success(cached);
        }
        return Failure(
          ProfileFailure(
            ProfileFailureType.profileNotFound,
            message: '${ProfileFailureMessages.profileNotFoundForUid} $uid',
          ),
        );
      }

      final profile = modelOrNull.toEntity();
      profile.validate();
      _profileCache[uid] = profile;
      return Success(profile);
    } catch (error) {
      final cached = _profileCache[uid];
      if (cached != null) {
        return Success(cached);
      }

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

      final modelOrNull = await _remoteDataSource.getProfile(uid);
      if (modelOrNull == null) {
        return const Failure(
          ProfileFailure(
            ProfileFailureType.unknown,
            message: ProfileFailureMessages.profileCreatedButNotFoundOnReadBack,
          ),
        );
      }

      final profile = modelOrNull.toEntity();
      profile.validate();
      _profileCache[uid] = profile;
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
      profile.validate();

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
        bio: profile.bio,
        avatarUrl: profile.avatarUrl,
        gender: profile.gender,
        age: profile.age,
        rating: profile.rating,
        trophies: profile.trophies,
      );

      _profileCache[profile.uid] = profile;
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
      _profileCache[uid] = profile;
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
      _profileCache[uid] = profile;
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
  Future<Result<List<Profile>, ProfileFailure>> getFriends(String uid) async {
    if (uid.trim().isEmpty) {
      return const Failure(
        ProfileFailure(
          ProfileFailureType.invalidName,
          message: ProfileValidationMessages.uidCannotBeEmpty,
        ),
      );
    }

    try {
      final models = await _remoteDataSource.getFriends(uid);
      final profiles = models.map((model) => model.toEntity()).toList();
      for (final profile in profiles) {
        profile.validate();
        _profileCache[profile.uid] = profile;
      }
      _friendsCache[uid] = profiles;
      return Success(profiles);
    } catch (error) {
      final cachedFriends = _friendsCache[uid];
      if (cachedFriends != null) {
        return Success(cachedFriends);
      }
      final mappedException = mapProfileFirestoreException(error);
      final failure = _errorMapper.map(mappedException);
      return Failure(failure);
    }
  }

  @override
  Future<Result<List<Profile>, ProfileFailure>> getProfilesByIds(
    List<String> uids,
  ) async {
    final normalized = uids.where((uid) => uid.trim().isNotEmpty).toSet();
    if (normalized.isEmpty) {
      return const Success(<Profile>[]);
    }

    try {
      final models = await _remoteDataSource.getProfilesByIds(
        normalized.toList(),
      );
      final profiles = models.map((model) => model.toEntity()).toList();
      for (final profile in profiles) {
        profile.validate();
        _profileCache[profile.uid] = profile;
      }
      return Success(profiles);
    } catch (error) {
      final cached = normalized
          .map((uid) => _profileCache[uid])
          .whereType<Profile>()
          .toList();
      if (cached.isNotEmpty) {
        return Success(cached);
      }
      final mappedException = mapProfileFirestoreException(error);
      final failure = _errorMapper.map(mappedException);
      return Failure(failure);
    }
  }

  @override
  Future<Result<void, ProfileFailure>> sendFriendRequest({
    required String requesterUid,
    required String recipientUid,
  }) async {
    if (requesterUid.trim().isEmpty || recipientUid.trim().isEmpty) {
      return const Failure(
        ProfileFailure(
          ProfileFailureType.invalidName,
          message: ProfileValidationMessages.uidCannotBeEmpty,
        ),
      );
    }

    try {
      await _remoteDataSource.sendFriendRequest(
        requesterUid: requesterUid,
        recipientUid: recipientUid,
      );
      return const Success(null);
    } catch (error) {
      final mappedException = mapProfileFirestoreException(error);
      final failure = _errorMapper.map(mappedException);
      return Failure(failure);
    }
  }

  @override
  Future<Result<void, ProfileFailure>> acceptFriendRequest(
    String requestId,
  ) async {
    if (requestId.trim().isEmpty) {
      return const Failure(
        ProfileFailure(
          ProfileFailureType.invalidName,
          message: ProfileValidationMessages.uidCannotBeEmpty,
        ),
      );
    }

    try {
      await _remoteDataSource.acceptFriendRequest(requestId);
      _friendsCache.clear();
      return const Success(null);
    } catch (error) {
      final mappedException = mapProfileFirestoreException(error);
      final failure = _errorMapper.map(mappedException);
      return Failure(failure);
    }
  }

  @override
  Future<Result<void, ProfileFailure>> declineFriendRequest(
    String requestId,
  ) async {
    if (requestId.trim().isEmpty) {
      return const Failure(
        ProfileFailure(
          ProfileFailureType.invalidName,
          message: ProfileValidationMessages.uidCannotBeEmpty,
        ),
      );
    }

    try {
      await _remoteDataSource.declineFriendRequest(requestId);
      return const Success(null);
    } catch (error) {
      final mappedException = mapProfileFirestoreException(error);
      final failure = _errorMapper.map(mappedException);
      return Failure(failure);
    }
  }

  @override
  Future<Result<void, ProfileFailure>> removeFriend({
    required String userUid,
    required String friendUid,
  }) async {
    if (userUid.trim().isEmpty || friendUid.trim().isEmpty) {
      return const Failure(
        ProfileFailure(
          ProfileFailureType.invalidName,
          message: ProfileValidationMessages.uidCannotBeEmpty,
        ),
      );
    }

    try {
      await _remoteDataSource.removeFriend(
        userUid: userUid,
        friendUid: friendUid,
      );
      _friendsCache.clear();
      return const Success(null);
    } catch (error) {
      final mappedException = mapProfileFirestoreException(error);
      final failure = _errorMapper.map(mappedException);
      return Failure(failure);
    }
  }
}
