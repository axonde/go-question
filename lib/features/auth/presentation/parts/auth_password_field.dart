part of '../auth_screen.dart';

class _AuthPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggleObscure;

  const _AuthPasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: 'Пароль',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
          onPressed: onToggleObscure,
        ),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Введите пароль';
        if (v.length < 6) return 'Минимум 6 символов';
        return null;
      },
    );
  }
}
