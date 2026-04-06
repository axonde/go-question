import 'package:auto_route/auto_route.dart';
import 'package:go_question/config/main_scaffold.dart';
import 'package:go_question/config/router/guards/already_logged_in_guard.dart';
import 'package:go_question/config/router/guards/auth_guard.dart';
import 'package:go_question/config/router/guards/verify_mail_guard.dart';
import 'package:go_question/features/auth/presentation/pages/login_page.dart';
import 'package:go_question/features/auth/presentation/pages/signin_page.dart';
import 'package:go_question/features/auth/presentation/pages/verify_mail_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  final AuthGuard authGuard;
  final AlreadyLoggedInGuard alreadyLoggedInGuard;
  final VerifyMailGuard verifyMailGuard;

  AppRouter({
    required this.authGuard,
    required this.alreadyLoggedInGuard,
    required this.verifyMailGuard,
  });

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/',
      page: MainRoute.page,
      guards: [authGuard],
      initial: true,
    ),
    AutoRoute(
      path: '/login',
      page: LoginRoute.page,
      guards: [alreadyLoggedInGuard],
    ),
    AutoRoute(
      path: '/signup',
      page: SigninRoute.page,
      guards: [alreadyLoggedInGuard],
    ),
    AutoRoute(
      path: '/verify',
      page: VerifyMailRoute.page,
      guards: [verifyMailGuard],
    ),
  ];
}
