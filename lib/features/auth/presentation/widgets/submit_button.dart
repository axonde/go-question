import 'package:flutter/material.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';

class SubmitButton extends StatelessWidget {
  final bool isLogin;
  final bool isLoading;
  final VoidCallback onPressed;

  const SubmitButton.login({required this.isLoading, required this.onPressed})
    : isLogin = true;
  const SubmitButton.signin({required this.isLoading, required this.onPressed})
    : isLogin = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: GoButton(onPressed: () {}, text: 'отправить'),
    );
  }
}
