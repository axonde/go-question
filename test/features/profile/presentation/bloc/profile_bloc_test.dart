import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/profile/domain/entities/user_profile_entity.dart';
import 'package:go_question/features/profile/domain/errors/profile_failure.dart';
import 'package:go_question/features/profile/domain/repositories/i_user_repository.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late ProfileBloc bloc;
  late MockUserRepository mockRepo;

  const tUid = 'test-uid-123';

  const tProfile = UserProfile(
    uid: tUid,
    name: 'Иван Иванов',
    age: 25,
    visitedEventsCount: 7,
  );

  setUp(() {
    mockRepo = MockUserRepository();
    bloc = ProfileBloc(mockRepo);
  });

  tearDown(() => bloc.close());

  test('начальное состояние — ProfileStatus.initial', () {
    expect(bloc.state.status, equals(ProfileStatus.initial));
    expect(bloc.state.profile, isNull);
    expect(bloc.state.errorMessage, isNull);
  });

  group('ProfileLoadRequested', () {
    test(
      'должен сначала эмитить loading, затем loaded с данными профиля',
      () async {
        when(
          () => mockRepo.getUserProfile(tUid),
        ).thenAnswer((_) async => const Success(tProfile));

        final states = <ProfileState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(const ProfileLoadRequested(tUid));
        await bloc.stream.firstWhere((s) => s.isLoaded);

        await subscription.cancel();

        expect(states.length, equals(2));

        expect(states[0].status, equals(ProfileStatus.loading));
        expect(states[0].profile, isNull);

        expect(states[1].status, equals(ProfileStatus.loaded));
        expect(states[1].profile, equals(tProfile));
        expect(states[1].errorMessage, isNull);
      },
    );

    test(
      'должен эмитить loading, затем failure при ошибке репозитория',
      () async {
        const tFailure = ProfileFailure(
          ProfileFailureType.server,
          message: 'Ошибка загрузки профиля',
        );

        when(
          () => mockRepo.getUserProfile(tUid),
        ).thenAnswer((_) async => const Failure(tFailure));

        final states = <ProfileState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(const ProfileLoadRequested(tUid));
        await bloc.stream.firstWhere((s) => s.isFailure);

        await subscription.cancel();

        expect(states.length, equals(2));

        expect(states[0].status, equals(ProfileStatus.loading));

        expect(states[1].status, equals(ProfileStatus.failure));
        expect(states[1].errorMessage, equals('Ошибка загрузки профиля'));
        expect(states[1].profile, isNull);
      },
    );

    test(
      'должен эмитить failure с сообщением notFound при отсутствии профиля',
      () async {
        const tFailure = ProfileFailure(
          ProfileFailureType.notFound,
          message: 'Профиль пользователя не найден',
        );

        when(
          () => mockRepo.getUserProfile(tUid),
        ).thenAnswer((_) async => const Failure(tFailure));

        bloc.add(const ProfileLoadRequested(tUid));
        final state = await bloc.stream.firstWhere((s) => s.isFailure);

        expect(state.status, equals(ProfileStatus.failure));
        expect(state.errorMessage, equals('Профиль пользователя не найден'));
      },
    );

    test('должен вызывать getUserProfile с переданным uid', () async {
      when(
        () => mockRepo.getUserProfile(any()),
      ).thenAnswer((_) async => const Success(tProfile));

      bloc.add(const ProfileLoadRequested(tUid));
      await bloc.stream.firstWhere((s) => s.isLoaded);

      verify(() => mockRepo.getUserProfile(tUid)).called(1);
    });
  });
}
