import 'package:auto_route/auto_route.dart';
import 'package:go_question/config/main_nav_page.dart';
import 'package:go_question/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:go_question/features/auth/presentation/pages/auth_flow_page.dart';
import 'package:go_question/features/profile/presentation/pages/profile_initialization_page.dart';

part 'router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  const AuthGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    resolver.next();
  }
}

class GuestGuard extends AutoRouteGuard {
  final IAuthRepository _authRepository;

  const GuestGuard(this._authRepository);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final canAccessGuestOnlyPages =
        _authRepository.getCurrentUser() == null ||
        !_authRepository.isCurrentUserEmailVerified();

    if (canAccessGuestOnlyPages) {
      resolver.next();
      return;
    }

    resolver.redirectUntil(const MainRoute());
  }
}

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard;
  final GuestGuard guestGuard;

  AppRouter({required this.authGuard, required this.guestGuard});

  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/', page: MainRoute.page, initial: true),
    AutoRoute(
      path: '/profile-init',
      page: ProfileInitializationRoute.page,
      guards: [authGuard],
    ),
    AutoRoute(path: '/auth', page: AuthFlowRoute.page, guards: [guestGuard]),
    RedirectRoute(path: '*', redirectTo: '/'),
  ];
}
