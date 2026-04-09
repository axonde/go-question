import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/achievements/data/source/achievements_remote_data_source.dart';
import 'package:go_question/features/achievements/domain/entities/achievement_view.dart';
import 'package:go_question/features/achievements/domain/errors/achievement_exceptions.dart';
import 'package:go_question/features/achievements/domain/errors/achievement_failures.dart';
import 'package:go_question/features/achievements/domain/repositories/i_achievements_repository.dart';

class AchievementsRepositoryImpl implements IAchievementsRepository {
  final IAchievementsRemoteDataSource _remoteDataSource;

  const AchievementsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<AchievementView>, AchievementFailure>> getAchievements(
    String uid,
  ) async {
    try {
      final achievements = await _remoteDataSource.getAchievements(uid);
      return Success(achievements);
    } on AchievementProfileNotFoundException {
      return const Failure(
        AchievementFailure(AchievementFailureType.profileNotFound),
      );
    } on AchievementFetchException {
      return const Failure(
        AchievementFailure(AchievementFailureType.fetchFailed),
      );
    } catch (_) {
      return const Failure(
        AchievementFailure(AchievementFailureType.fetchFailed),
      );
    }
  }

  @override
  Future<Result<List<AchievementView>, AchievementFailure>> openAchievements(
    String uid,
  ) async {
    try {
      final achievements = await _remoteDataSource.openAchievements(uid);
      return Success(achievements);
    } on AchievementProfileNotFoundException {
      return const Failure(
        AchievementFailure(AchievementFailureType.profileNotFound),
      );
    } on AchievementUpdateException {
      return const Failure(
        AchievementFailure(AchievementFailureType.updateFailed),
      );
    } catch (_) {
      return const Failure(
        AchievementFailure(AchievementFailureType.updateFailed),
      );
    }
  }

  @override
  Future<Result<void, AchievementFailure>> markAllAsViewed(String uid) async {
    try {
      await _remoteDataSource.markAllAsViewed(uid);
      return const Success(null);
    } on AchievementUpdateException {
      return const Failure(
        AchievementFailure(AchievementFailureType.updateFailed),
      );
    } catch (_) {
      return const Failure(
        AchievementFailure(AchievementFailureType.updateFailed),
      );
    }
  }

  @override
  Future<Result<void, AchievementFailure>> unlockAchievement({
    required String uid,
    required String achievementId,
    bool markAsUnseen = true,
  }) async {
    try {
      await _remoteDataSource.unlockAchievement(
        uid: uid,
        achievementId: achievementId,
        markAsUnseen: markAsUnseen,
      );
      return const Success(null);
    } on AchievementUpdateException {
      return const Failure(
        AchievementFailure(AchievementFailureType.updateFailed),
      );
    } catch (_) {
      return const Failure(
        AchievementFailure(AchievementFailureType.updateFailed),
      );
    }
  }
}
