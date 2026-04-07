import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/features/auth/presentation/widgets/email_field.dart';
import 'package:go_question/features/auth/presentation/widgets/google_button.dart';
import 'package:go_question/features/auth/presentation/widgets/header.dart';
import 'package:go_question/features/auth/presentation/widgets/name_field.dart';
import 'package:go_question/features/auth/presentation/widgets/password_field.dart';
import 'package:go_question/features/auth/presentation/widgets/submit_button.dart';
import 'package:go_question/features/auth/presentation/widgets/switch_button.dart';

class SignUpPage extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onMoveToLogin;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onSubmit;
  final VoidCallback onGoogleSignIn;

  const SignUpPage({
    super.key,
    required this.isLoading,
    required this.onMoveToLogin,
    required this.onNameChanged,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Header.signUp(),
                  const SizedBox(height: 32),
                  NameField(onChanged: onNameChanged),
                  const SizedBox(height: 16),
                  EmailField(onChanged: onEmailChanged),
                  const SizedBox(height: 16),
                  PasswordField(onChanged: onPasswordChanged),
                  const SizedBox(height: 40),
                  SubmitButton.signUp(
                    isLoading: isLoading,
                    onPressed: onSubmit,
                  ),
                  const SizedBox(height: 12),
                  GoogleButton(isLoading: isLoading, onPressed: onGoogleSignIn),
                ],
              ),
            ),
            SwitchButton.signUp(onToggle: onMoveToLogin),
          ],
        ),
      ),
    );
  }
}
