import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/main_scaffold.dart';
import 'package:go_question/core/widgets/app_background.dart';
import 'package:go_question/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:go_question/features/auth/presentation/cubit/auth_state.dart';
import 'package:go_question/features/auth/presentation/pages/auth_page.dart';
import 'package:go_question/features/auth/presentation/pages/email_verification_page.dart';
import 'injection_container/injection_container.dart' as di;

class GoQuestionApp extends StatelessWidget {
  const GoQuestionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Question',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      builder: (context, child) => AppBackground(child: child!),
      home: BlocProvider(
        create: (_) => di.sl<AuthCubit>(),
        child: const _AuthGate(),
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is AuthAuthenticated) {
          return const MainScaffold();
        }
        if (state is AuthAwaitingVerification) {
          return EmailVerificationPage(email: state.email);
        }
        return const AuthPage();
      },
    );
  }
}
