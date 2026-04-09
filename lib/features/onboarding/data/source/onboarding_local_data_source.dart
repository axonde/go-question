import 'package:shared_preferences/shared_preferences.dart';

abstract interface class OnboardingLocalDataSource {
  bool getOnboardingStatus();
  Future<void> setOnboardingCompleted();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const onboardingKey = 'is_onboarding_completed';

  OnboardingLocalDataSourceImpl(this.sharedPreferences);

  @override
  bool getOnboardingStatus() {
    return sharedPreferences.getBool(onboardingKey) ?? false;
  }

  @override
  Future<void> setOnboardingCompleted() async {
    await sharedPreferences.setBool(onboardingKey, true);
  }
}
