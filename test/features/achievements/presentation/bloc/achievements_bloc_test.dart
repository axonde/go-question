import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/core/constants/achievement_constants.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/achievements/domain/entities/achievement_view.dart';
import 'package:go_question/features/achievements/domain/errors/achievement_failures.dart';
import 'package:go_question/features/achievements/domain/repositories/i_achievements_repository.dart';
import 'package:go_question/features/achievements/presentation/bloc/achievements_bloc.dart';

class FakeAchievementsRepository implements IAchievementsRepository {
  Result<List<AchievementView>, AchievementFailure>? openResult;
  Result<List<AchievementView>, AchievementFailure>? getResult;
  Result<void, AchievementFailure>? markViewedResult;

  @override
  Future<Result<List<AchievementView>, AchievementFailure>> getAchievements(
    String uid,
  ) async => getResult!;

  @override
  Future<Result<void, AchievementFailure>> markAllAsViewed(String uid) async =>
      markViewedResult!;

  @override
  Future<Result<List<AchievementView>, AchievementFailure>> openAchievements(
    String uid,
  ) async => openResult!;

  @override
  Future<Result<void, AchievementFailure>> unlockAchievement({
    required String uid,
    required String achievementId,
    bool markAsUnseen = true,
  }) async => const Success(null);
}

void main() {
  late FakeAchievementsRepository repository;
  late AchievementsBloc bloc;

  const unseen = AchievementView(
    id: AchievementConstants.firstOpenAchievements,
    title: 'Первый шаг',
    description: 'Откройте окно достижений впервые.',
    isUnlocked: true,
    isViewed: false,
  );

  const seen = AchievementView(
    id: AchievementConstants.firstOpenAchievements,
    title: 'Первый шаг',
    description: 'Откройте окно достижений впервые.',
    isUnlocked: true,
    isViewed: true,
  );

  setUp(() {
    repository = FakeAchievementsRepository();
    bloc = AchievementsBloc(repository);
  });

  tearDown(() async {
    await bloc.close();
  });

  test('open emits loading then success with unseen achievement', () async {
    repository.openResult = const Success(<AchievementView>[unseen]);

    final states = <AchievementsState>[];
    final subscription = bloc.stream.listen(states.add);

    bloc.add(const AchievementsOpenedRequested('uid-1'));
    await Future<void>.delayed(Duration.zero);

    expect(states.length, 2);
    expect(states.first.status, AchievementsStatus.loading);
    expect(states.last.status, AchievementsStatus.success);
    expect(states.last.hasUnseenAchievements, isTrue);

    await subscription.cancel();
  });

  test('viewed flow clears unseen flag after mark and refresh', () async {
    repository.markViewedResult = const Success(null);
    repository.getResult = const Success(<AchievementView>[seen]);

    final states = <AchievementsState>[];
    final subscription = bloc.stream.listen(states.add);

    bloc.add(const AchievementsViewedRequested('uid-1'));
    await Future<void>.delayed(Duration.zero);

    expect(states, isNotEmpty);
    expect(states.last.status, AchievementsStatus.success);
    expect(states.last.hasUnseenAchievements, isFalse);

    await subscription.cancel();
  });
}
