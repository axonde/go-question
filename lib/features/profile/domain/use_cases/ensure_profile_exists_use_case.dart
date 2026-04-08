import '../../../../core/types/result.dart';
import '../entities/profile.dart';
import '../errors/profile_failure.dart';
import '../repositories/i_profile_repository.dart';

/// Use case: ensureProfileExists.
///
/// **Purpose:** Eliminate "auth exists but profile doesn't" state.
///
/// **Behavior:**
/// 1. Checks if profile exists for uid
/// 2. If exists → returns success (no-op)
/// 3. If not → creates initial profile with provided name
///
/// **Idempotency:** Safe to call multiple times; subsequent calls are no-op.
///
/// **Design decisions:**
/// - Partial success is normal state (profile missing after auth)
/// - Profile.name is the single source of truth
/// - Domain enforces all invariants
/// - Returns Result<T> only, no exceptions propagate to caller
///
/// **Input:**
/// - uid: user identifier
/// - initialName: name for creation if profile doesn't exist
///
/// **Output:**
/// - Success(profile): existing or newly created
/// - Failure: domain/data/network errors
class EnsureProfileExistsUseCase {
  final IProfileRepository _repository;

  const EnsureProfileExistsUseCase({required IProfileRepository repository})
    : _repository = repository;

  /// Ensures profile exists. Idempotent.
  ///
  /// Returns:
  /// - Success(profile) if profile exists or was created
  /// - Failure(InvalidName) if initialName is invalid
  /// - Failure(Server/Network) if data layer fails
  Future<Result<Profile, ProfileFailure>> call({
    required String uid,
    required String initialName,
  }) async {
    // Step 1: Try to get existing profile
    final getResult = await _repository.getProfile(uid);

    // Step 2: If not found, create initial; otherwise return existing
    return getResult.foldAsync<Result<Profile, ProfileFailure>>(
      onSuccess: (profile) async {
        // Profile exists → idempotent success (no-op)
        return Success(profile);
      },
      onFailure: (failure) async {
        // Profile doesn't exist → create initial
        if (failure.type == ProfileFailureType.profileNotFound) {
          return await _repository.createInitialProfile(
            uid: uid,
            initialName: initialName,
          );
        }
        // Other failure types (network, server, etc.) propagate
        return Failure(failure);
      },
    );
  }
}
