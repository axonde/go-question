part of '../pages/login_page.dart';

class _SwitchButton extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onToggle;

  const _SwitchButton.login({required this.onToggle}) : isLogin = true;
  const _SwitchButton.signin({required this.onToggle}) : isLogin = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: GoButton(
        onPressed: onToggle,
        text: isLogin ? 'Зарегистрироваться' : 'Войти',
        colors: GoButtonColors.standard(),
      ),
    );
  }
}
