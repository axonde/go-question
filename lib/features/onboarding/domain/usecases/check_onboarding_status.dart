import 'package:go_question/features/onboarding/domain/repositories/i_onboarding_repository.dart';

class CheckOnboardingStatus {
  final IOnboardingRepository repository;

  CheckOnboardingStatus(this.repository);

  Future<bool> call() async {
    // Keep it future for usecases for consistency and ease of use in BLoC
    return repository.getOnboardingStatus();
  }
}
