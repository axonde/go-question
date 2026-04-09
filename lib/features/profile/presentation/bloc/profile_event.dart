part of 'profile_bloc.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

final class _ProfileStreamUpdated extends ProfileEvent {
  final Profile profile;

  const _ProfileStreamUpdated(this.profile);
}

/// Request to ensure profile exists. Idempotent operation.
///
/// **Context:** Called immediately after successful auth to guarantee
/// profile exists before allowing access to main app.
///
/// **Safety:** Calling multiple times is safe (idempotent by use case design).
final class EnsureProfileExistsRequested extends ProfileEvent {
  /// User ID from Firebase Auth
  final String uid;

  /// Email from auth context.
  final String initialEmail;

  /// Name to use for initial profile creation (if profile doesn't exist).
  /// Usually from Auth.displayName or signup form.
  final String initialName;

  /// Nickname to use for initial profile creation.
  final String initialNickname;

  const EnsureProfileExistsRequested({
    required this.uid,
    required this.initialEmail,
    required this.initialName,
    required this.initialNickname,
  });
}

/// Explicit retry for profile creation on recoverable failure.
///
/// **Trigger:** User presses "Retry" button on failure screen.
///
/// **Flow:**
/// 1. User sees recoverable failure with retry button
/// 2. User clicks retry
/// 3. ProfileBloc emits loading state
/// 4. Calls ensureProfileExists again (idempotent)
/// 5. Returns to success or shows failure again
///
/// **Idempotent:** Safe to call repeatedly.
final class ProfileRetryRequested extends ProfileEvent {
  /// User ID from Firebase Auth
  final String uid;

  /// Email from auth context.
  final String initialEmail;

  /// Name to use for initial profile creation
  final String initialName;

  /// Nickname to use for initial profile creation.
  final String initialNickname;

  const ProfileRetryRequested({
    required this.uid,
    required this.initialEmail,
    required this.initialName,
    required this.initialNickname,
  });
}

/// Update an existing profile after the user fills missing data.
final class ProfileUpdateRequested extends ProfileEvent {
  final Profile profile;

  const ProfileUpdateRequested(this.profile);
}

/// Refreshes profile from repository without changing local edits.
final class ProfileRefreshRequested extends ProfileEvent {
  final String uid;

  const ProfileRefreshRequested(this.uid);
}
