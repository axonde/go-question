import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_question/config/router/app_router.dart';

/// Redirects unauthenticated users to [LoginRoute].
/// Users with unverified email are redirected to [VerifyMailRoute].
class AuthGuard extends AutoRouteGuard {
  final FirebaseAuth _firebaseAuth;

  AuthGuard({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      resolver.redirect(const LoginRoute());
    } else if (!user.emailVerified) {
      resolver.redirect(const VerifyMailRoute());
    } else {
      resolver.next(true);
    }
  }
}
