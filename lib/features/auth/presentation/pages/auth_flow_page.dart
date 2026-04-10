import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/features/auth/domain/entities/auth_page.dart';

import '../bloc/auth_bloc.dart';
import 'login_page.dart';
import 'sign_up_page.dart';
import 'verify_mail_page.dart';

@RoutePage()
class AuthFlowPage extends StatelessWidget {
  const AuthFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage ||
          previous.hint != current.hint,
      listener: (context, state) {
        if (state.status == AuthStatus.awaitingProfile ||
            state.status == AuthStatus.authenticated) {
          final route = ModalRoute.of(context);
          if (route is PopupRoute<dynamic>) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              final navigator = Navigator.of(context, rootNavigator: true);
              if (navigator.canPop()) {
                navigator.pop();
              }
            });
          }
          return;
        }

        final messenger = ScaffoldMessenger.of(context);
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          messenger.showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          context.read<AuthBloc>().add(const AuthTransientCleared());
          return;
        }
        if (state.hint != null && state.hint!.isNotEmpty) {
          messenger.showSnackBar(SnackBar(content: Text(state.hint!)));
          context.read<AuthBloc>().add(const AuthTransientCleared());
        }
      },
      builder: (context, state) {
        if (state.status == AuthStatus.loading ||
            state.status == AuthStatus.awaitingProfile ||
            state.status == AuthStatus.authenticated) {
          return const _AuthLoadingScreen();
        }

        switch (state.currentPage) {
          case AuthPage.login:
            return LoginPage(
              isLoading: state.isLoading,
              onMoveToSignIn: () {
                context.read<AuthBloc>().add(
                  const AuthPageChanged(AuthPage.signUp),
                );
              },
              onEmailChanged: (value) {
                context.read<AuthBloc>().add(AuthLoginEmailChanged(value));
              },
              onPasswordChanged: (value) {
                context.read<AuthBloc>().add(AuthLoginPasswordChanged(value));
              },
              onSubmit: () {
                context.read<AuthBloc>().add(const AuthSignInRequested());
              },
              onGoogleSignIn: () {
                context.read<AuthBloc>().add(const AuthGoogleSignInRequested());
              },
            );
          case AuthPage.signUp:
            return SignUpPage(
              isLoading: state.isLoading,
              onMoveToLogin: () {
                context.read<AuthBloc>().add(
                  const AuthPageChanged(AuthPage.login),
                );
              },
              onNicknameChanged: (value) {
                context.read<AuthBloc>().add(AuthSignUpNicknameChanged(value));
              },
              onEmailChanged: (value) {
                context.read<AuthBloc>().add(AuthSignUpEmailChanged(value));
              },
              onPasswordChanged: (value) {
                context.read<AuthBloc>().add(AuthSignUpPasswordChanged(value));
              },
              onSubmit: () {
                context.read<AuthBloc>().add(const AuthSignUpRequested());
              },
              onGoogleSignIn: () {
                context.read<AuthBloc>().add(const AuthGoogleSignInRequested());
              },
            );
          case AuthPage.verifyEmail:
            return VerifyMailPage(
              isLoading: state.isLoading,
              email: state.verificationEmail ?? '',
              onCheckVerified: () {
                context.read<AuthBloc>().add(
                  const AuthCheckEmailVerifiedRequested(),
                );
              },
              onResend: () {
                context.read<AuthBloc>().add(
                  const AuthResendVerificationRequested(),
                );
              },
              onBackToSignIn: () {
                context.read<AuthBloc>().add(
                  const AuthCancelVerificationRequested(),
                );
              },
            );
        }
      },
    );
  }
}

class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
