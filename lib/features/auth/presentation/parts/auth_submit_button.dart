part of '../auth_screen.dart';

class _AuthSubmitButton extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onPressed;

  const _AuthSubmitButton({required this.isLogin, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final loading = state is AuthLoading;
        return ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
          ),
          child: loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isLogin ? 'Войти' : 'Зарегистрироваться'),
        );
      },
    );
  }
}
