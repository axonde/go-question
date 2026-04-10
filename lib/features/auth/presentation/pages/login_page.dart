import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:go_question/config/router/router.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/buttons/go_button/gq_close_button.dart';

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
    void closeLogin() {
      final navigator = Navigator.of(context, rootNavigator: true);
      if (navigator.canPop()) {
        navigator.pop();
      } else if (context.mounted) {
        context.router.replace(const MainRoute());
      }
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background/background.webp',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: UiConstants.leftPadding,
                right: UiConstants.rightPadding,
                top: UiConstants.topPadding,
                bottom: UiConstants.bottomPadding,
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GqCloseButton(onTap: closeLogin),
                    ),
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
          ),
        ],
      ),
    );
  }
}
