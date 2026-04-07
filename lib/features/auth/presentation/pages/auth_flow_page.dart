import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/main_nav_page.dart';

import '../../../../injection_container/injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import 'login_page.dart';
import 'sign_up_page.dart';
import 'verify_mail_page.dart';

class AuthFlowPage extends StatelessWidget {
  const AuthFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(const AuthStarted()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage ||
            previous.hint != current.hint,
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            messenger.showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
            context.read<AuthBloc>().add(const AuthTransientCleared());
            return;
          }
          if (state.hint != null && state.hint!.isNotEmpty) {
            messenger.showSnackBar(SnackBar(content: Text(state.hint!)));
            context.read<AuthBloc>().add(const AuthTransientCleared());
          }
        },
        builder: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            return const MainNavPage();
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
                  context.read<AuthBloc>().add(
                    const AuthGoogleSignInRequested(),
                  );
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
                onNameChanged: (value) {
                  context.read<AuthBloc>().add(AuthSignUpNameChanged(value));
                },
                onEmailChanged: (value) {
                  context.read<AuthBloc>().add(AuthSignUpEmailChanged(value));
                },
                onPasswordChanged: (value) {
                  context.read<AuthBloc>().add(
                    AuthSignUpPasswordChanged(value),
                  );
                },
                onSubmit: () {
                  context.read<AuthBloc>().add(const AuthSignUpRequested());
                },
                onGoogleSignIn: () {
                  context.read<AuthBloc>().add(
                    const AuthGoogleSignInRequested(),
                  );
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
      ),
    );
  }
}
