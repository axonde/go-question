part of '../auth_screen.dart';

class _AuthGoogleButton extends StatelessWidget {
  const _AuthGoogleButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final loading = state is AuthLoading;
        return OutlinedButton.icon(
          onPressed: loading
              ? null
              : () => context.read<AuthCubit>().signInWithGoogle(),
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
