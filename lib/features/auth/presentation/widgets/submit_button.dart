import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_text_styles.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';

class SubmitButton extends StatelessWidget {
  final bool isLogin;
  final bool isLoading;
  final VoidCallback onPressed;

  const SubmitButton.login({
    super.key,
    required this.isLoading,
    required this.onPressed,
  }) : isLogin = true;
  const SubmitButton.signUp({
    super.key,
    required this.isLoading,
    required this.onPressed,
  }) : isLogin = false;

  @override
  Widget build(BuildContext context) {
    return GQButton(
      aspectRatio: 110 / 20,
      fontSize: AppTextStyles.button.fontSize,
      widthFactor: 1,
      onPressed: onPressed,
      isLoading: isLoading,
      text: isLogin ? 'Войти' : 'Зарегистрироваться',
    );
  }
}
