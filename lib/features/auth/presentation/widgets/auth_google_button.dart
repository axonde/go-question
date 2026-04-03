import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

/// Кнопка входа через Google.
class AuthGoogleButton extends StatelessWidget {
  const AuthGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final loading = state is AuthLoading;
        return OutlinedButton.icon(
          onPressed:
              loading ? null : () => context.read<AuthCubit>().signInWithGoogle(),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
          ),
          icon: const Icon(Icons.g_mobiledata, size: 24),
          label: const Text('Войти через Google'),
        );
      },
    );
  }
}
