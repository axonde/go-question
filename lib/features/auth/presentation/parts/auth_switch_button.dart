part of '../auth_screen.dart';

class _AuthSwitchButton extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onToggle;

  const _AuthSwitchButton({required this.isLogin, required this.onToggle});

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
