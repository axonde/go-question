abstract interface class IOnboardingRepository {
  bool getOnboardingStatus();
  Future<void> setOnboardingCompleted();
}
