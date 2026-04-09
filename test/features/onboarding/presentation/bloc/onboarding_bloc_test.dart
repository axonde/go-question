import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/features/onboarding/domain/usecases/check_onboarding_status.dart';
import 'package:go_question/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:go_question/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckOnboardingStatus extends Mock implements CheckOnboardingStatus {}

class MockCompleteOnboarding extends Mock implements CompleteOnboarding {}

void main() {
  late OnboardingBloc bloc;
  late MockCheckOnboardingStatus mockCheckStatus;
  late MockCompleteOnboarding mockCompleteOnboarding;

  setUp(() {
    mockCheckStatus = MockCheckOnboardingStatus();
    mockCompleteOnboarding = MockCompleteOnboarding();
    bloc = OnboardingBloc(mockCheckStatus, mockCompleteOnboarding);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be initial', () {
    expect(bloc.state.status, OnboardingStatus.initial);
    expect(bloc.state.currentPageIndex, 0);
  });

  test(
    'should emit [checking, completed] when onboarding is already done',
    () async {
      // arrange
      when(() => mockCheckStatus()).thenAnswer((_) async => true);

      // assert later
      final expected = [
        predicate<OnboardingState>(
          (state) => state.status == OnboardingStatus.checking,
        ),
        predicate<OnboardingState>(
          (state) => state.status == OnboardingStatus.completed,
        ),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(const OnboardingStarted());
    },
  );

  test(
    'should emit [checking, required] when onboarding is NOT done',
    () async {
      // arrange
      when(() => mockCheckStatus()).thenAnswer((_) async => false);

      // assert later
      final expected = [
        predicate<OnboardingState>(
          (state) => state.status == OnboardingStatus.checking,
        ),
        predicate<OnboardingState>(
          (state) => state.status == OnboardingStatus.required,
        ),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(const OnboardingStarted());
    },
  );

  test(
    'should emit new page index when OnboardingPageChanged is added',
    () async {
      // arrange
      final expected = [
        predicate<OnboardingState>((state) => state.currentPageIndex == 1),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(const OnboardingPageChanged(1));
    },
  );

  test(
    'should emit [completed] and call complete usecase when OnboardingCompletedRequested is added',
    () async {
      // arrange
      when(() => mockCompleteOnboarding()).thenAnswer((_) async => {});

      // assert later
      final expected = [
        predicate<OnboardingState>(
          (state) => state.status == OnboardingStatus.completed,
        ),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(const OnboardingCompletedRequested());

      // wait for async operations
      await untilCalled(() => mockCompleteOnboarding());
      verify(() => mockCompleteOnboarding()).called(1);
    },
  );
}
