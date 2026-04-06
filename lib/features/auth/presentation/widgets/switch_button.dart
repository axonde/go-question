import 'package:flutter/widgets.dart';
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
    return SizedBox(
      height: 60,
      child: GQButton(
        onPressed: onToggle,
        text: isLogin ? 'Зарегистрироваться' : 'Войти',
      ),
    );
  }
}
