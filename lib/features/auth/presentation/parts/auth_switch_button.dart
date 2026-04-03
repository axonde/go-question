part of '../auth_screen.dart';

class _AuthSwitchButton extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onToggle;

  const _AuthSwitchButton({required this.isLogin, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onToggle,
      child: Text(
        isLogin
            ? 'Нет аккаунта? Зарегистрироваться'
            : 'Уже есть аккаунт? Войти',
      ),
    );
  }
}
