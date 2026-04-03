import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/verification_change_email_button.dart';
import '../widgets/verification_check_button.dart';
import '../widgets/verification_resend_button.dart';

/// Страница ожидания подтверждения email.
class EmailVerificationPage extends StatelessWidget {
  final String email;
  const EmailVerificationPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (_, current) =>
          current is AuthAwaitingVerification && current.hint != null,
      listener: (context, state) {
        if (state is AuthAwaitingVerification && state.hint != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.hint!)));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 72,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Подтвердите почту',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Мы отправили письмо на\n$email\n\n'
                  'Перейдите по ссылке в письме, затем вернитесь сюда.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),
                const VerificationCheckButton(),
                const SizedBox(height: 12),
                const VerificationResendButton(),
                const SizedBox(height: 24),
                const VerificationChangeEmailButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
