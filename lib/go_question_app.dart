import 'package:flutter/material.dart';
import 'package:go_question/config/main_scaffold.dart';
import 'package:go_question/config/theme/app_theme.dart';
import 'package:go_question/core/widgets/app_background.dart';

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
    // Точки входа в auth-экран временно закомментированы.
    // Причина: в параллельном PR разрабатывается BLoC-связка для auth flow,
    // и до её мерджа приложение запускается через MainScaffold.
    // После интеграции BLoC вернуть entry-point на auth gate.
    return AppBackground(child: MainScaffold());
  }
}
