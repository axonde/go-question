import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/features/profile/domain/entities/profile.dart';

void main() {
  group('Profile Entity', () {
    test('creates valid profile with all fields', () {
      final profile = Profile(
        uid: 'test-uid',
        name: 'Test User',
        age: 25,
        visitedEventsCount: 5,
        createdEventsCount: 2,
      );

      profile.validate(); // Should not throw
      expect(profile.uid, equals('test-uid'));
      expect(profile.name, equals('Test User'));
      expect(profile.age, equals(25));
      expect(profile.visitedEventsCount, equals(5));
      expect(profile.createdEventsCount, equals(2));
    });

    test('creates valid profile with nullable age', () {
      final profile = Profile(uid: 'test-uid', name: 'Test User', age: null);

      profile.validate(); // Should not throw
      expect(profile.age, isNull);
    });

    test('fails validation when uid is empty', () {
      final profile = Profile(uid: '', name: 'Test User');

      expect(() => profile.validate(), throwsA(isA<ArgumentError>()));
    });

    test('fails validation when name is empty', () {
      final profile = Profile(uid: 'test-uid', name: '');

      expect(() => profile.validate(), throwsA(isA<ArgumentError>()));
    });

    test('fails validation when name is whitespace-only', () {
      final profile = Profile(uid: 'test-uid', name: '   ');

      expect(() => profile.validate(), throwsA(isA<ArgumentError>()));
    });

    test('fails validation when age is negative', () {
      final profile = Profile(uid: 'test-uid', name: 'Test User', age: -1);

      expect(() => profile.validate(), throwsA(isA<ArgumentError>()));
    });

    test('fails validation when visitedEventsCount is negative', () {
      final profile = Profile(
        uid: 'test-uid',
        name: 'Test User',
        visitedEventsCount: -1,
      );

      expect(() => profile.validate(), throwsA(isA<ArgumentError>()));
    });

    test('fails validation when createdEventsCount is negative', () {
      final profile = Profile(
        uid: 'test-uid',
        name: 'Test User',
        createdEventsCount: -1,
      );

      expect(() => profile.validate(), throwsA(isA<ArgumentError>()));
    });

    test('defaults visitedEventsCount and createdEventsCount to 0', () {
      final profile = Profile(uid: 'test-uid', name: 'Test User');

      profile.validate();
      expect(profile.visitedEventsCount, equals(0));
      expect(profile.createdEventsCount, equals(0));
    });
  });
}
