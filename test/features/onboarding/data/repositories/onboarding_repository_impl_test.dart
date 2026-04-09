import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:go_question/features/onboarding/data/source/onboarding_local_data_source.dart';
import 'package:mocktail/mocktail.dart';

class MockOnboardingLocalDataSource extends Mock
    implements OnboardingLocalDataSource {}

void main() {
  late OnboardingRepositoryImpl repository;
  late MockOnboardingLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockOnboardingLocalDataSource();
    repository = OnboardingRepositoryImpl(mockDataSource);
  });

  group('getOnboardingStatus', () {
    test('should return status from data source', () {
      // arrange
      when(() => mockDataSource.getOnboardingStatus()).thenReturn(true);
      // act
      final result = repository.getOnboardingStatus();
      // assert
      expect(result, true);
      verify(() => mockDataSource.getOnboardingStatus()).called(1);
    });
  });

  group('setOnboardingCompleted', () {
    test('should call setOnboardingCompleted on data source', () async {
      // arrange
      when(
        () => mockDataSource.setOnboardingCompleted(),
      ).thenAnswer((_) async => {});
      // act
      await repository.setOnboardingCompleted();
      // assert
      verify(() => mockDataSource.setOnboardingCompleted()).called(1);
    });
  });
}
