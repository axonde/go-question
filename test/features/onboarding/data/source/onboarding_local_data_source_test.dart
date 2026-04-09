import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/features/onboarding/data/source/onboarding_local_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late OnboardingLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = OnboardingLocalDataSourceImpl(mockSharedPreferences);
  });

  const onboardingKey = 'is_onboarding_completed';

  group('getOnboardingStatus', () {
    test('should return true when onboarding is completed in SharedPreferences', () {
      // arrange
      when(() => mockSharedPreferences.getBool(onboardingKey)).thenReturn(true);
      // act
      final result = dataSource.getOnboardingStatus();
      // assert
      expect(result, true);
      verify(() => mockSharedPreferences.getBool(onboardingKey)).called(1);
    });

    test('should return false when onboarding is not in SharedPreferences', () {
      // arrange
      when(() => mockSharedPreferences.getBool(onboardingKey)).thenReturn(null);
      // act
      final result = dataSource.getOnboardingStatus();
      // assert
      expect(result, false);
    });
  });

  group('setOnboardingCompleted', () {
    test('should call setBool with the correct key and value', () async {
      // arrange
      when(() => mockSharedPreferences.setBool(onboardingKey, true))
          .thenAnswer((_) async => true);
      // act
      await dataSource.setOnboardingCompleted();
      // assert
      verify(() => mockSharedPreferences.setBool(onboardingKey, true)).called(1);
    });
  });
}
