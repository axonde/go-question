import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/features/onboarding/domain/usecases/check_onboarding_status.dart';
import 'package:go_question/features/onboarding/domain/usecases/complete_onboarding.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CheckOnboardingStatus _checkOnboardingStatus;
  final CompleteOnboarding _completeOnboarding;

  OnboardingBloc(this._checkOnboardingStatus, this._completeOnboarding)
    : super(const OnboardingState.initial()) {
    on<OnboardingStarted>(_onStarted);
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingCompletedRequested>(_onCompletedRequested);
  }

  Future<void> _onStarted(
    OnboardingStarted event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(status: OnboardingStatus.checking));
    final isCompleted = await _checkOnboardingStatus();
    if (isCompleted) {
      emit(state.copyWith(status: OnboardingStatus.completed));
    } else {
      emit(state.copyWith(status: OnboardingStatus.required));
    }
  }

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(currentPageIndex: event.pageIndex));
  }

  Future<void> _onCompletedRequested(
    OnboardingCompletedRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    await _completeOnboarding();
    emit(state.copyWith(status: OnboardingStatus.completed));
  }
}
