import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_text_styles.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';

class GoogleButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const GoogleButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GQButton(
      icon: Icons.g_mobiledata,
      text: 'Войти через Google',
      fontSize: AppTextStyles.button.fontSize,
      aspectRatio: 110 / 20,
      onPressed: onPressed,
      isLoading: isLoading,
      widthFactor: 1,
    );
  }
}
