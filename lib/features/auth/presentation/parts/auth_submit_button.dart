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
        return SizedBox(
          height: 100,
          child: GoButton(
            onPressed: loading ? () {} : onPressed,
            text: isLogin ? 'Войти' : 'Зарегистрироваться',
            colors: GoButtonColors.standard(),
          ),
        );
      },
    );
  }
}
