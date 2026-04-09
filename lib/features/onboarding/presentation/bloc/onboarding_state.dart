part of 'onboarding_bloc.dart';

enum OnboardingStatus { initial, checking, required, completed }

class OnboardingState {
  final OnboardingStatus status;
  final int currentPageIndex;

  const OnboardingState({required this.status, required this.currentPageIndex});

  const OnboardingState.initial()
    : status = OnboardingStatus.initial,
      currentPageIndex = 0;

  OnboardingState copyWith({OnboardingStatus? status, int? currentPageIndex}) {
    return OnboardingState(
      status: status ?? this.status,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    );
  }
}
