import 'package:go_question/features/onboarding/domain/repositories/i_onboarding_repository.dart';

class CompleteOnboarding {
  final IOnboardingRepository repository;

  CompleteOnboarding(this.repository);

  Future<void> call() async {
    await repository.setOnboardingCompleted();
  }
}
