import '../../../../core/types/result.dart';
import '../entities/profile.dart';
import '../errors/profile_failure.dart';

/// Profile repository interface.
///
/// Defines contract for profile data operations.
abstract class IProfileRepository {
  /// Retrieves profile by uid.
  /// Returns Success(profile) if found, Failure(profileNotFound) if not.
  Future<Result<Profile, ProfileFailure>> getProfile(String uid);
  Stream<Profile?> watchProfile(String uid);

  /// Retrieves profile by numeric registration id.
  Future<Result<Profile, ProfileFailure>> getProfileByRegistrationId(
    int registrationId,
  );

  /// Creates a new profile with initial data.
  /// Validates profile invariants.
  /// Returns Success(profile) on success, Failure for any domain/data errors.
  Future<Result<Profile, ProfileFailure>> createInitialProfile({
    required String uid,
    required String initialEmail,
    required String initialName,
    required String initialNickname,
  });

  /// Updates profile in data source.
  Future<Result<Profile, ProfileFailure>> updateProfile(Profile profile);

  /// Increments visited events count for profile.
  Future<Result<Profile, ProfileFailure>> incrementVisitedEventsCount(
    String uid,
  );

  /// Increments created events count for profile.
  Future<Result<Profile, ProfileFailure>> incrementCreatedEventsCount(
    String uid,
  );

  /// Returns full friend profiles for a user.
  Future<Result<List<Profile>, ProfileFailure>> getFriends(String uid);
  Stream<List<Profile>> watchFriends(String uid);

  /// Returns profile documents by id list.
  Future<Result<List<Profile>, ProfileFailure>> getProfilesByIds(
    List<String> uids,
  );
  Future<Result<List<Profile>, ProfileFailure>> getTopProfilesByTrophies({
    int limit = 100,
  });
  Stream<List<Profile>> watchTopProfilesByTrophies({int limit = 100});

  /// Sends a friend request from one user to another.
  Future<Result<void, ProfileFailure>> sendFriendRequest({
    required String requesterUid,
    required String recipientUid,
  });

  /// Accepts a friend request by id.
  Future<Result<void, ProfileFailure>> acceptFriendRequest(String requestId);

  /// Declines a friend request by id.
  Future<Result<void, ProfileFailure>> declineFriendRequest(String requestId);

  /// Removes a friend relation from both users.
  Future<Result<void, ProfileFailure>> removeFriend({
    required String userUid,
    required String friendUid,
  });
}
