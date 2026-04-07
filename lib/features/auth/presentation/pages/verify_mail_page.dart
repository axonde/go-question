import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';

class VerifyMailPage extends StatelessWidget {
  final bool isLoading;
  final String email;
  final VoidCallback onCheckVerified;
  final VoidCallback onResend;
  final VoidCallback onBackToSignIn;

  const VerifyMailPage({
    super.key,
    required this.isLoading,
    required this.email,
    required this.onCheckVerified,
    required this.onResend,
    required this.onBackToSignIn,
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Verify your email',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 16),
              Text(
                email,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              GQButton(
                onPressed: isLoading ? () {} : onCheckVerified,
                text: 'I have verified my email',
              ),
              const SizedBox(height: 12),
              GQButton(
                onPressed: isLoading ? () {} : onResend,
                text: 'Resend verification email',
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: isLoading ? null : onBackToSignIn,
                child: const Text('Wrong email? Back to sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
