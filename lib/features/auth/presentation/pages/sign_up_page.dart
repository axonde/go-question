import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:go_question/config/router/router.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/app_background.dart';
import 'package:go_question/core/widgets/buttons/go_button/gq_close_button.dart';
import 'package:go_question/features/auth/presentation/widgets/email_field.dart';
import 'package:go_question/features/auth/presentation/widgets/google_button.dart';
import 'package:go_question/features/auth/presentation/widgets/header.dart';
import 'package:go_question/features/auth/presentation/widgets/nickname_field.dart';
import 'package:go_question/features/auth/presentation/widgets/password_field.dart';
import 'package:go_question/features/auth/presentation/widgets/submit_button.dart';
import 'package:go_question/features/auth/presentation/widgets/switch_button.dart';

class SignUpPage extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onMoveToLogin;
  final ValueChanged<String> onNicknameChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onSubmit;
  final VoidCallback onGoogleSignIn;

  const SignUpPage({
    super.key,
    required this.isLoading,
    required this.onMoveToLogin,
    required this.onNicknameChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onSubmit,
    required this.onGoogleSignIn,
  });

  @override
  Widget build(BuildContext context) {
    void closeSignUp() {
      final navigator = Navigator.of(context, rootNavigator: true);
      if (navigator.canPop()) {
        navigator.pop();
      } else if (context.mounted) {
        context.router.replace(const MainRoute());
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AppBackground(
        child: SafeArea(
          minimum: const EdgeInsets.only(
            left: UiConstants.leftPadding,
            right: UiConstants.rightPadding,
            top: UiConstants.topPadding,
            bottom: UiConstants.bottomPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GqCloseButton(onTap: closeSignUp),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Header.signUp(),
                    const SizedBox(height: 32),
                    NicknameField(onChanged: onNicknameChanged),
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
      ),
    );
  }
}
