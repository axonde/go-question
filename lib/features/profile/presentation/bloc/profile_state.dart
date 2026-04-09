part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, success, recoverableFailure }

class ProfileState {
  final ProfileStatus status;
  final Profile? profile;
  final String? errorMessage;
  final ProfileFailureType? failureType;
  final String? failureDetails;

  const ProfileState({
    required this.status,
    this.profile,
    this.errorMessage,
    this.failureType,
    this.failureDetails,
  });

  /// Initial state before profile initialization begins
  const ProfileState.initial()
    : status = ProfileStatus.initial,
      profile = null,
      errorMessage = null,
      failureType = null,
      failureDetails = null;

  /// Profile initialization in progress
  const ProfileState.loading()
    : status = ProfileStatus.loading,
      profile = null,
      errorMessage = null,
      failureType = null,
      failureDetails = null;

  /// Profile successfully created or already existed
  factory ProfileState.success(Profile profile) =>
      ProfileState(status: ProfileStatus.success, profile: profile);

  /// Profile creation/fetch failed with recoverable error.
  ///
  /// This is the critical UX state for partial success:
  /// * Auth succeeded (user logged in)
  /// * Profile creation failed (temporary network, server issue, etc.)
  /// * User is NOT logged out (retryable)
  /// * UI shows retry button
  factory ProfileState.recoverableFailure({
    required String message,
    required ProfileFailureType failureType,
    required String failureMessage,
  }) => ProfileState(
    status: ProfileStatus.recoverableFailure,
    errorMessage: message,
    failureType: failureType,
    failureDetails: failureMessage,
  );

  bool get isLoading => status == ProfileStatus.loading;
  bool get isSuccess => status == ProfileStatus.success;
  bool get isRecoverableFailure => status == ProfileStatus.recoverableFailure;

  ProfileState copyWith({
    ProfileStatus? status,
    Profile? profile,
    String? errorMessage,
    ProfileFailureType? failureType,
    String? failureDetails,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
      failureType: failureType ?? this.failureType,
      failureDetails: failureDetails ?? this.failureDetails,
    );
  }
}
