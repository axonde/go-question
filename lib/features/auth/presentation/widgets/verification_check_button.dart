import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

/// Кнопка «Я подтвердил почту» — проверяет статус верификации.
class VerificationCheckButton extends StatelessWidget {
  const VerificationCheckButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final loading = state is AuthLoading;
        return ElevatedButton(
          onPressed:
              loading ? null : () => context.read<AuthCubit>().checkEmailVerified(),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
          ),
          child: loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Я подтвердил почту'),
        );
      },
    );
  }
}
