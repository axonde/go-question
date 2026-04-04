import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/main_scaffold.dart';
import 'package:go_question/features/auth/presentation/auth_screen.dart';
import 'package:go_question/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:go_question/features/auth/presentation/cubit/auth_state.dart';
import 'package:go_question/features/auth/presentation/email_verification_screen.dart';
import 'package:go_question/features/profile/presentation/profile_screen.dart';
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
      ),
      home: BlocProvider(
        create: (_) => di.sl<AuthCubit>(),
        child: const _AuthGate(),
      ),
    );
  }
}

/// Переключает экраны в зависимости от состояния авторизации.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        // if (state is AuthLoading) {
        //   return const Scaffold(
        //     body: Center(child: CircularProgressIndicator()),
        //   );
        // }
        // if (state is AuthAuthenticated) {
        //   return const MainScaffold();
        // }
        // if (state is AuthAwaitingVerification) {
        //   return EmailVerificationScreen(email: state.email);
        // // }
        // return const AuthScreen();
        return ProfileScreen();
      },
    );
  }
}
