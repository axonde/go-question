import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

/// Кнопка повторной отправки письма верификации.
class VerificationResendButton extends StatelessWidget {
  const VerificationResendButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final loading = state is AuthLoading;
        return OutlinedButton.icon(
          onPressed: loading
              ? null
              : () => context.read<AuthCubit>().resendVerificationEmail(),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
          ),
          icon: const Icon(Icons.send_outlined),
          label: const Text('Отправить письмо снова'),
        );
      },
    );
  }
}
