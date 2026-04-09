import 'package:go_question/features/onboarding/data/source/onboarding_local_data_source.dart';
import 'package:go_question/features/onboarding/domain/repositories/i_onboarding_repository.dart';

class OnboardingRepositoryImpl implements IOnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl(this.localDataSource);

  @override
  bool getOnboardingStatus() {
    return localDataSource.getOnboardingStatus();
  }

  @override
  Future<void> setOnboardingCompleted() async {
    await localDataSource.setOnboardingCompleted();
  }
}
