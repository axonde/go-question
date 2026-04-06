import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_question/config/router/app_router.dart';

/// Only allows users with an unverified email to access [VerifyMailRoute].
/// Unauthenticated users are redirected to [LoginRoute].
/// Fully authenticated users are redirected to [MainRoute].
class VerifyMailGuard extends AutoRouteGuard {
  final FirebaseAuth _firebaseAuth;

  VerifyMailGuard({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      resolver.redirect(const LoginRoute());
    } else if (user.emailVerified) {
      resolver.redirect(const MainRoute());
    } else {
      resolver.next(true);
    }
  }
}
