import 'package:auto_route/auto_route.dart';
import 'package:go_question/config/main_nav_page.dart';
import 'package:go_question/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:go_question/features/auth/presentation/pages/auth_flow_page.dart';
import 'package:go_question/features/onboarding/domain/repositories/i_onboarding_repository.dart';
import 'package:go_question/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:go_question/features/profile/presentation/pages/profile_initialization_page.dart';

part 'router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  final IAuthRepository _authRepository;
  final IOnboardingRepository _onboardingRepository;

  const AuthGuard(this._authRepository, this._onboardingRepository);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // Intercept with Onboarding if not completed on this device
    if (!_onboardingRepository.getOnboardingStatus()) {
      resolver.redirectUntil(const OnboardingRoute());
      return;
    }

    final canAccessMain =
        _authRepository.getCurrentUser() != null &&
        _authRepository.isCurrentUserEmailVerified();

    if (canAccessMain) {
      resolver.next();
      return;
    }

    resolver.redirectUntil(const AuthFlowRoute());
  }
}

class GuestGuard extends AutoRouteGuard {
  final IAuthRepository _authRepository;
  final IOnboardingRepository _onboardingRepository;

  const GuestGuard(this._authRepository, this._onboardingRepository);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final canAccessGuestOnlyPages =
        _authRepository.getCurrentUser() == null ||
        !_authRepository.isCurrentUserEmailVerified();

    if (!canAccessGuestOnlyPages) {
      resolver.redirectUntil(const MainRoute());
      return;
    }

    // Intercept with Onboarding if not completed
    if (!_onboardingRepository.getOnboardingStatus()) {
      resolver.redirectUntil(const OnboardingRoute());
      return;
    }

    resolver.next();
  }
}

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard;
  final GuestGuard guestGuard;

  AppRouter({required this.authGuard, required this.guestGuard});

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/',
      page: MainRoute.page,
      initial: true,
      guards: [authGuard],
    ),
    AutoRoute(
      path: '/profile-init',
      page: ProfileInitializationRoute.page,
      guards: [authGuard],
    ),
    AutoRoute(path: '/auth', page: AuthFlowRoute.page, guards: [guestGuard]),
    AutoRoute(path: '/onboarding', page: OnboardingRoute.page),
    RedirectRoute(path: '*', redirectTo: '/'),
  ];
}
