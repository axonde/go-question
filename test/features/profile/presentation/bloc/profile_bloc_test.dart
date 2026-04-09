import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/profile/domain/entities/profile.dart';
import 'package:go_question/features/profile/domain/errors/profile_failure.dart';
import 'package:go_question/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';

class FakeProfileRepository implements IProfileRepository {
  @override
  Future<Result<Profile, ProfileFailure>> createInitialProfile({
    required String uid,
    required String initialEmail,
    required String initialName,
    required String initialNickname,
  }) async => throw UnimplementedError();

  @override
  Future<Result<Profile, ProfileFailure>> getProfile(String uid) async =>
      throw UnimplementedError();

  @override
  Future<Result<Profile, ProfileFailure>> incrementCreatedEventsCount(
    String uid,
  ) async => throw UnimplementedError();

  @override
  Future<Result<Profile, ProfileFailure>> incrementVisitedEventsCount(
    String uid,
  ) async => throw UnimplementedError();

  @override
  Future<Result<List<Profile>, ProfileFailure>> getFriends(String uid) async =>
      throw UnimplementedError();

  @override
  Future<Result<List<Profile>, ProfileFailure>> getProfilesByIds(
    List<String> uids,
  ) async => throw UnimplementedError();

  @override
  Future<Result<void, ProfileFailure>> sendFriendRequest({
    required String requesterUid,
    required String recipientUid,
  }) async => throw UnimplementedError();

  @override
  Future<Result<void, ProfileFailure>> acceptFriendRequest(
    String requestId,
  ) async => throw UnimplementedError();

  @override
  Future<Result<void, ProfileFailure>> declineFriendRequest(
    String requestId,
  ) async => throw UnimplementedError();

  @override
  Future<Result<void, ProfileFailure>> removeFriend({
    required String userUid,
    required String friendUid,
  }) async => throw UnimplementedError();

  @override
  Future<Result<Profile, ProfileFailure>> updateProfile(
    Profile profile,
  ) async => throw UnimplementedError();
}

void main() {
  test('ProfileBloc starts in initial state', () {
    final bloc = ProfileBloc(FakeProfileRepository());
    expect(bloc.state.status, ProfileStatus.initial);
    bloc.close();
  });
}
