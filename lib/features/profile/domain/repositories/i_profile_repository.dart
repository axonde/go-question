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

  /// Creates a new profile with initial data.
  /// Validates profile invariants.
  /// Returns Success(profile) on success, Failure for any domain/data errors.
  Future<Result<Profile, ProfileFailure>> createInitialProfile({
    required String uid,
    required String initialName,
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
}
