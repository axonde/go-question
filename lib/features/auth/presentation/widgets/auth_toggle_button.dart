import 'package:flutter/material.dart';

/// Переключатель между режимами входа и регистрации.
class AuthToggleButton extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onToggle;

  const AuthToggleButton({
    super.key,
    required this.isLogin,
    required this.onToggle,
  });

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
