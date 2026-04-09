import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/features/onboarding/domain/repositories/i_onboarding_repository.dart';
import 'package:go_question/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:mocktail/mocktail.dart';

class MockOnboardingRepository extends Mock implements IOnboardingRepository {}

void main() {
  late CompleteOnboarding usecase;
  late MockOnboardingRepository mockRepository;

  setUp(() {
    mockRepository = MockOnboardingRepository();
    usecase = CompleteOnboarding(mockRepository);
  });

  test('should call setOnboardingCompleted on the repository', () async {
    // arrange
    when(() => mockRepository.setOnboardingCompleted())
        .thenAnswer((_) async => {});
    // act
    await usecase();
    // assert
    verify(() => mockRepository.setOnboardingCompleted()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
