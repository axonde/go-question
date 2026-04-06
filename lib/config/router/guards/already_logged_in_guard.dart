import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_question/config/router/app_router.dart';

/// Redirects fully authenticated users away from auth pages to [MainRoute].
/// Allows unauthenticated or unverified users to proceed.
class AlreadyLoggedInGuard extends AutoRouteGuard {
  final FirebaseAuth _firebaseAuth;

  AlreadyLoggedInGuard({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final user = _firebaseAuth.currentUser;
    if (user != null && user.emailVerified) {
      resolver.redirect(const MainRoute());
    } else {
      resolver.next(true);
    }
  }
}
