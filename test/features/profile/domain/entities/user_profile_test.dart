import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/features/profile/domain/entities/user_profile.dart';

void main() {
  group('UserProfile invariants', () {
    test('trims non-empty name and applies default counters', () {
      final profile = UserProfile.create(uid: 'uid-1', name: '  Alice  ');

      expect(profile.name, 'Alice');
      expect(profile.visitedEventsCount, 0);
      expect(profile.createdEventsCount, 0);
      expect(profile.age, isNull);
    });

    test('throws when name is blank after trim', () {
      expect(
        () => UserProfile(uid: 'uid-1', name: '   '),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws when age is negative', () {
      expect(
        () => UserProfile(uid: 'uid-1', name: 'Alice', age: -1),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws when counters are negative', () {
      expect(
        () => UserProfile(uid: 'uid-1', name: 'Alice', visitedEventsCount: -1),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => UserProfile(uid: 'uid-1', name: 'Alice', createdEventsCount: -1),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
