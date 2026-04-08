import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/core/types/result.dart' as result_type;
import 'package:go_question/features/profile/domain/entities/user_profile.dart';
import 'package:go_question/features/profile/domain/errors/profile_failure.dart';
import 'package:go_question/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';

class FakeProfileRepository implements IProfileRepository {
  result_type.Result<UserProfile, ProfileFailure> ensureResult;
  int ensureCalls = 0;

  FakeProfileRepository({required this.ensureResult});

  @override
  Future<result_type.Result<UserProfile?, ProfileFailure>> getProfile(
    String uid,
  ) async {
    return const result_type.Success<UserProfile?, ProfileFailure>(null);
  }

  @override
  Future<result_type.Result<UserProfile, ProfileFailure>> ensureProfileExists({
    required String uid,
    String? preferredName,
    String? email,
  }) async {
    ensureCalls += 1;
    return ensureResult;
  }

  @override
  Future<result_type.Result<UserProfile, ProfileFailure>> updateProfile({
    required String uid,
    required String name,
    int? age,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<result_type.Result<void, ProfileFailure>> incrementVisitedEventsCount(
    String uid, {
    int by = 1,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<result_type.Result<void, ProfileFailure>> incrementCreatedEventsCount(
    String uid, {
    int by = 1,
  }) async {
    throw UnimplementedError();
  }
}

void main() {
  group('ProfileBloc', () {
    test('emits loading then ready on successful ensure', () async {
      final profile = UserProfile.create(uid: 'uid-1', name: 'Alice');
      final repository = FakeProfileRepository(
        ensureResult: result_type.Success<UserProfile, ProfileFailure>(profile),
      );
      final bloc = ProfileBloc(repository);

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<ProfileState>((s) => s.status == ProfileStatus.loading),
          predicate<ProfileState>(
            (s) =>
                s.status == ProfileStatus.ready && s.profile?.name == 'Alice',
          ),
        ]),
      );

      bloc.add(
        const ProfileEnsureRequested(
          uid: 'uid-1',
          preferredName: 'Alice',
          email: 'alice@mail.com',
        ),
      );

      await expectation;
      expect(repository.ensureCalls, 1);
      await bloc.close();
    });

    test(
      'keeps auth-independent recoverable failure and retries ensure',
      () async {
        final repository = FakeProfileRepository(
          ensureResult: const result_type.Failure<UserProfile, ProfileFailure>(
            ProfileFailure(ProfileFailureType.network),
          ),
        );
        final bloc = ProfileBloc(repository);

        bloc.add(
          const ProfileEnsureRequested(
            uid: 'uid-2',
            preferredName: 'Bob',
            email: 'bob@mail.com',
          ),
        );
        await Future<void>.delayed(Duration.zero);

        expect(bloc.state.status, ProfileStatus.recoverableFailure);
        expect(bloc.state.failure?.type, ProfileFailureType.network);

        repository.ensureResult =
            result_type.Success<UserProfile, ProfileFailure>(
              UserProfile.create(uid: 'uid-2', name: 'Bob'),
            );

        final expectation = expectLater(
          bloc.stream,
          emitsThrough(
            predicate<ProfileState>((s) => s.status == ProfileStatus.ready),
          ),
        );

        bloc.add(const ProfileRetryRequested());
        await expectation;

        expect(repository.ensureCalls, 2);
        expect(bloc.state.profile?.name, 'Bob');
        await bloc.close();
      },
    );
  });
}
