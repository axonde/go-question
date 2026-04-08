import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/profile/domain/entities/profile.dart';
import 'package:go_question/features/profile/domain/errors/profile_failure.dart';
import 'package:go_question/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:go_question/features/profile/domain/use_cases/ensure_profile_exists_use_case.dart';

/// Fake repository for testing use case logic
class _FakeProfileRepository implements IProfileRepository {
  bool shouldReturnNotFound = false;

  @override
  Future<Result<Profile, ProfileFailure>> getProfile(String uid) async {
    if (shouldReturnNotFound) {
      return Failure(
        const ProfileFailure(
          ProfileFailureType.profileNotFound,
          message: 'Not found for test',
        ),
      );
    }
    return Success(Profile(uid: uid, name: 'Existing User'));
  }

  @override
  Future<Result<Profile, ProfileFailure>> createInitialProfile({
    required String uid,
    required String initialName,
  }) async {
    return Success(Profile(uid: uid, name: initialName));
  }

  @override
  Future<Result<Profile, ProfileFailure>> updateProfile(Profile profile) async {
    return Success(profile);
  }

  @override
  Future<Result<Profile, ProfileFailure>> incrementVisitedEventsCount(
    String uid,
  ) async {
    return Success(Profile(uid: uid, name: 'Test', visitedEventsCount: 1));
  }

  @override
  Future<Result<Profile, ProfileFailure>> incrementCreatedEventsCount(
    String uid,
  ) async {
    return Success(Profile(uid: uid, name: 'Test', createdEventsCount: 1));
  }
}

void main() {
  group('EnsureProfileExistsUseCase', () {
    late EnsureProfileExistsUseCase useCase;
    late _FakeProfileRepository repository;

    setUp(() {
      repository = _FakeProfileRepository();
      useCase = EnsureProfileExistsUseCase(repository: repository);
    });

    test('returns existing profile when it exists (idempotent)', () async {
      repository.shouldReturnNotFound = false;

      final result = await useCase(
        uid: 'test-uid',
        initialName: 'Initial Name',
      );

      expect(result, isA<Success>());
      final profile = (result as Success).value;
      expect(profile.uid, equals('test-uid'));
      expect(profile.name, equals('Existing User'));
    });

    test('creates and returns new profile when not found', () async {
      repository.shouldReturnNotFound = true;

      final result = await useCase(uid: 'new-uid', initialName: 'New User');

      expect(result, isA<Success>());
      final profile = (result as Success).value;
      expect(profile.uid, equals('new-uid'));
      expect(profile.name, equals('New User'));
    });

    test('is idempotent - calling twice is safe', () async {
      repository.shouldReturnNotFound = true;

      // First call
      final result1 = await useCase(
        uid: 'idempotent-uid',
        initialName: 'Idempotent User',
      );

      // Simulate profile now exists
      repository.shouldReturnNotFound = false;

      // Second call should return success (no-op)
      final result2 = await useCase(
        uid: 'idempotent-uid',
        initialName: 'Idempotent User',
      );

      expect(result1, isA<Success>());
      expect(result2, isA<Success>());
    });
  });
}
