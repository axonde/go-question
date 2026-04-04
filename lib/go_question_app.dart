import 'package:flutter/material.dart';
import 'package:go_question/config/main_scaffold.dart';
import 'package:go_question/config/theme/app_theme.dart';
import 'package:go_question/features/auth/presentation/pages/login_page.dart';
import 'package:go_question/features/auth/presentation/pages/signin_page.dart';

class GoQuestionApp extends StatelessWidget {
  const GoQuestionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Question',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.main(),
      home: _AuthGate(),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    // return LoginPage(onMoveToSignIn: () {});
    // return SigninPage(onMoveToSignIn: () {});
    return MainScaffold();
  }
}
