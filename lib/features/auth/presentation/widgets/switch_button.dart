import 'package:flutter/widgets.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/app_text_styles.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';

class SwitchButton extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onToggle;

  const SwitchButton.login({super.key, required this.onToggle})
    : isLogin = true;
  const SwitchButton.signUp({super.key, required this.onToggle})
    : isLogin = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: GQButton(
        onPressed: onToggle,
        text: isLogin ? 'Зарегистрироваться' : 'Войти',
        aspectRatio: 110 / 20,
        widthFactor: 1,
        fontSize: AppTextStyles.button.fontSize,
        baseColor: AppColors.primary,
        mainGradient: const LinearGradient(
          colors: [Color(0xFF0092F5), Color(0xFF008FF2)],
        ),
        outerGradient: const LinearGradient(
          colors: [Color(0xFF005BC0), Color(0xFF0055B8)],
        ),
      ),
    );
  }
}
