import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/features/profile/domain/entities/profile.dart';

void main() {
  group('Profile Entity', () {
    test('creates valid profile with all fields', () {
      const profile = Profile(
        uid: 'test-uid',
        email: 'user@test.dev',
        name: 'Test User',
        nickname: 'tester',
        trophies: 10,
        visitedEventsCount: 5,
        createdEventsCount: 2,
        joinedEventIds: ['event-1', 'event-2'],
        createdEventIds: ['created-1'],
      );

      profile.validate(); // Should not throw
      expect(profile.uid, equals('test-uid'));
      expect(profile.email, equals('user@test.dev'));
      expect(profile.name, equals('Test User'));
      expect(profile.nickname, equals('tester'));
      expect(profile.trophies, equals(10));
      expect(profile.visitedEventsCount, equals(5));
      expect(profile.createdEventsCount, equals(2));
      expect(profile.joinedEventIds, equals(['event-1', 'event-2']));
      expect(profile.createdEventIds, equals(['created-1']));
    });

    test('creates valid profile with nullable optional fields', () {
      const profile = Profile(
        uid: 'test-uid',
        email: 'user@test.dev',
        name: 'Test User',
        nickname: 'tester',
      );

      profile.validate(); // Should not throw
      expect(profile.birthDate, isNull);
      expect(profile.city, isNull);
    });

    test('fails validation when uid is empty', () {
      const profile = Profile(
        uid: '',
        email: 'user@test.dev',
        name: 'Test User',
        nickname: 'tester',
      );

      expect(() => profile.validate(), throwsA(isA<ArgumentError>()));
    });

    test('fails validation when email is empty', () {
      const profile = Profile(
        uid: 'test-uid',
        email: '',
        name: 'Test User',
        nickname: 'tester',
      );

      expect(() => profile.validate(), throwsA(isA<ArgumentError>()));
    });

    test('fails validation when name is empty', () {
      const profile = Profile(
        uid: 'test-uid',
        email: 'user@test.dev',
        name: '',
        nickname: 'tester',
      );

      expect(() => profile.validate(), throwsA(isA<ArgumentError>()));
    });

    test('fails validation when name is whitespace-only', () {
      const profile = Profile(
        uid: 'test-uid',
        email: 'user@test.dev',
        name: '   ',
        nickname: 'tester',
      );

      expect(() => profile.validate(), throwsA(isA<ArgumentError>()));
    });

    test('fails validation when nickname is empty', () {
      const profile = Profile(
        uid: 'test-uid',
        email: 'user@test.dev',
        name: 'Test User',
        nickname: '',
      );

      expect(() => profile.validate(), throwsA(isA<ArgumentError>()));
    });

    test('fails validation when birthDate is in the future', () {
      final profile = Profile(
        uid: 'test-uid',
        email: 'user@test.dev',
        name: 'Test User',
        nickname: 'tester',
        birthDate: DateTime.now().add(const Duration(days: 1)),
      );

      expect(() => profile.validate(), throwsA(isA<ArgumentError>()));
    });

    test('fails validation when trophies is negative', () {
      const profile = Profile(
        uid: 'test-uid',
        email: 'user@test.dev',
        name: 'Test User',
        nickname: 'tester',
        trophies: -1,
      );

      expect(() => profile.validate(), throwsA(isA<ArgumentError>()));
    });

    test('fails validation when visitedEventsCount is negative', () {
      const profile = Profile(
        uid: 'test-uid',
        email: 'user@test.dev',
        name: 'Test User',
        nickname: 'tester',
        visitedEventsCount: -1,
      );

      expect(() => profile.validate(), throwsA(isA<ArgumentError>()));
    });

    test('fails validation when createdEventsCount is negative', () {
      const profile = Profile(
        uid: 'test-uid',
        email: 'user@test.dev',
        name: 'Test User',
        nickname: 'tester',
        createdEventsCount: -1,
      );

      expect(() => profile.validate(), throwsA(isA<ArgumentError>()));
    });

    test('defaults counters and trophies to 0', () {
      const profile = Profile(
        uid: 'test-uid',
        email: 'user@test.dev',
        name: 'Test User',
        nickname: 'tester',
      );

      profile.validate();
      expect(profile.trophies, equals(0));
      expect(profile.visitedEventsCount, equals(0));
      expect(profile.createdEventsCount, equals(0));
      expect(profile.joinedEventIds, isEmpty);
      expect(profile.createdEventIds, isEmpty);
    });

    test('fails validation when joinedEventIds contains empty value', () {
      const profile = Profile(
        uid: 'test-uid',
        email: 'user@test.dev',
        name: 'Test User',
        nickname: 'tester',
        joinedEventIds: ['event-1', '   '],
      );

      expect(() => profile.validate(), throwsA(isA<ArgumentError>()));
    });

    test('fails validation when createdEventIds contains empty value', () {
      const profile = Profile(
        uid: 'test-uid',
        email: 'user@test.dev',
        name: 'Test User',
        nickname: 'tester',
        createdEventIds: [''],
      );

      expect(() => profile.validate(), throwsA(isA<ArgumentError>()));
    });
  });
}
