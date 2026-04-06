import 'package:flutter/material.dart';
import 'package:go_question/config/router/app_router.dart';
import 'package:go_question/config/theme/app_theme.dart';
import 'package:go_question/injection_container/injection_container.dart';

class GoQuestionApp extends StatelessWidget {
  const GoQuestionApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = sl<AppRouter>();
    return MaterialApp.router(
      title: 'Go Question',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.main(),
      routerConfig: router.config(),
    );
  }
}
