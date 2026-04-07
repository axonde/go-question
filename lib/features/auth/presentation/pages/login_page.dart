import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';

import '../widgets/email_field.dart';
import '../widgets/google_button.dart';
import '../widgets/header.dart';
import '../widgets/password_field.dart';
import '../widgets/submit_button.dart';
import '../widgets/switch_button.dart';

class LoginPage extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onMoveToSignIn;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onSubmit;
  final VoidCallback onGoogleSignIn;

  const LoginPage({
    super.key,
    required this.isLoading,
    required this.onMoveToSignIn,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onSubmit,
    required this.onGoogleSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.only(
          left: UiConstants.leftPadding,
          right: UiConstants.rightPadding,
          top: UiConstants.topPadding,
          bottom: UiConstants.bottomPadding,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Header.login(),
                    const SizedBox(height: 32),
                    EmailField(onChanged: onEmailChanged),
                    const SizedBox(height: 16),
                    PasswordField(onChanged: onPasswordChanged),
                    const SizedBox(height: 40),
                    SubmitButton.login(
                      isLoading: isLoading,
                      onPressed: onSubmit,
                    ),
                    const SizedBox(height: 12),
                    GoogleButton(
                      isLoading: isLoading,
                      onPressed: onGoogleSignIn,
                    ),
                  ],
                ),
              ),
              SwitchButton.login(onToggle: onMoveToSignIn),
            ],
          ),
        ),
      ),
    );
  }
}
