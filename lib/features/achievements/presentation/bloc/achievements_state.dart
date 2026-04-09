part of 'achievements_bloc.dart';

enum AchievementsStatus { initial, loading, success, failure }

class AchievementsState {
  final AchievementsStatus status;
  final List<AchievementView> achievements;
  final String? errorMessage;

  const AchievementsState({
    required this.status,
    this.achievements = const <AchievementView>[],
    this.errorMessage,
  });

  const AchievementsState.initial()
    : status = AchievementsStatus.initial,
      achievements = const <AchievementView>[],
      errorMessage = null;

  bool get hasUnseenAchievements =>
      achievements.any((item) => item.isUnlocked && !item.isViewed);

  AchievementsState copyWith({
    AchievementsStatus? status,
    List<AchievementView>? achievements,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AchievementsState(
      status: status ?? this.status,
      achievements: achievements ?? this.achievements,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
