import 'package:go_question/features/profile/domain/entities/user_profile_entity.dart';

enum ProfileStatus { initial, loading, loaded, failure }

class ProfileState {
  final ProfileStatus status;
  final UserProfile? profile;
  final String? errorMessage;

  const ProfileState({
    required this.status,
    this.profile,
    this.errorMessage,
  });

  const ProfileState.initial()
    : status = ProfileStatus.initial,
      profile = null,
      errorMessage = null;

  bool get isLoading => status == ProfileStatus.loading;
  bool get isLoaded => status == ProfileStatus.loaded;
  bool get isFailure => status == ProfileStatus.failure;

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    String? errorMessage,
    bool clearError = false,
    bool clearProfile = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: clearProfile ? null : (profile ?? this.profile),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
