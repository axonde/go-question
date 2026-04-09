part of 'achievements_bloc.dart';

sealed class AchievementsEvent {
  const AchievementsEvent();
}

final class AchievementsOpenedRequested extends AchievementsEvent {
  final String uid;

  const AchievementsOpenedRequested(this.uid);
}

final class AchievementsViewedRequested extends AchievementsEvent {
  final String uid;

  const AchievementsViewedRequested(this.uid);
}

final class AchievementsRefreshRequested extends AchievementsEvent {
  final String uid;

  const AchievementsRefreshRequested(this.uid);
}
