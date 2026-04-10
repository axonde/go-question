import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/achievements/domain/entities/achievement_view.dart';
import 'package:go_question/features/achievements/domain/errors/achievement_failures.dart';

abstract interface class IAchievementsRepository {
  Future<Result<List<AchievementView>, AchievementFailure>> getAchievements(
    String uid,
  );

  Future<Result<List<AchievementView>, AchievementFailure>> openAchievements(
    String uid,
  );

  Future<Result<void, AchievementFailure>> markAllAsViewed(String uid);

  Future<Result<void, AchievementFailure>> unlockAchievement({
    required String uid,
    required String achievementId,
    bool markAsUnseen = true,
  });
}
