part of '../pages/login_page.dart';

class _SubmitButton extends StatelessWidget {
  final bool isLogin;
  final bool isLoading;
  final VoidCallback onPressed;

  const _SubmitButton.login({required this.isLoading, required this.onPressed})
    : isLogin = true;
  const _SubmitButton.signin({required this.isLoading, required this.onPressed})
    : isLogin = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: GoButton(
        onPressed: isLoading ? () {} : onPressed,
        text: isLogin ? 'Войти' : 'Зарегистрироваться',
        colors: GoButtonColors.standard(),
      ),
    );
  }
}
