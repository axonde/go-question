import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/features/onboarding/domain/repositories/i_onboarding_repository.dart';
import 'package:go_question/features/onboarding/domain/usecases/check_onboarding_status.dart';
import 'package:mocktail/mocktail.dart';

class MockOnboardingRepository extends Mock implements IOnboardingRepository {}

void main() {
  late CheckOnboardingStatus usecase;
  late MockOnboardingRepository mockRepository;

  setUp(() {
    mockRepository = MockOnboardingRepository();
    usecase = CheckOnboardingStatus(mockRepository);
  });

  test('should get onboarding status from the repository', () async {
    // arrange
    when(() => mockRepository.getOnboardingStatus())
        .thenReturn(true);
    // act
    final result = await usecase();
    // assert
    expect(result, true);
    verify(() => mockRepository.getOnboardingStatus()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return false when onboarding is not completed', () async {
    // arrange
    when(() => mockRepository.getOnboardingStatus())
        .thenReturn(false);
    // act
    final result = await usecase();
    // assert
    expect(result, false);
    verify(() => mockRepository.getOnboardingStatus()).called(1);
  });
}
