import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/router/router.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:go_question/features/onboarding/presentation/pages/onboarding_slide_page.dart';
import 'package:go_question/injection_container/injection_container.dart';

@RoutePage()
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OnboardingBloc>()..add(const OnboardingStarted()),
      child: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state.status == OnboardingStatus.completed) {
            context.pushRoute(const AuthFlowRoute());
          }
        },
        builder: (context, state) {
          if (state.status == OnboardingStatus.checking) {
            return const Scaffold(
              backgroundColor: Color(0xFF1A1A1A),
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: const Color(0xFF1A1A1A),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        context.read<OnboardingBloc>().add(OnboardingPageChanged(index));
                      },
                      children: const [
                        OnboardingSlidePage(
                          title: 'Welcome to Go Question',
                          description: 'The ultimate app for event organizers and attendees.',
                          backgroundColor: Colors.transparent,
                        ),
                        OnboardingSlidePage(
                          title: 'Discover Events',
                          description: 'Find interesting events happening around you.',
                          backgroundColor: Colors.transparent,
                        ),
                        OnboardingSlidePage(
                          title: 'Connect with Others',
                          description: 'Meet new people and grow your network.',
                          backgroundColor: Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                  // Bottom Controls
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Dots Indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: state.currentPageIndex == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: state.currentPageIndex == index
                                    ? Colors.white
                                    : Colors.white24,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 32),
                        // Buttons
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                context.read<OnboardingBloc>().add(
                                  const OnboardingCompletedRequested(),
                                );
                              },
                              child: const Text(
                                'Skip',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 140, // Reduced fixed width for the button
                              child: GQButton(
                                onPressed: () {
                                  if (state.currentPageIndex < 2) {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    context.read<OnboardingBloc>().add(
                                      const OnboardingCompletedRequested(),
                                    );
                                  }
                                },
                                text: state.currentPageIndex < 2 ? 'Next' : 'Enter',
                                widthFactor: 1.0, // Internal factor override
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
