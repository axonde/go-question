part of '../auth_screen.dart';

class _AuthEmailField extends StatelessWidget {
  final TextEditingController controller;
  final RegExp emailRegex;

  const _AuthEmailField({required this.controller, required this.emailRegex});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Почта',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          return 'Введите email';
        }
        if (!emailRegex.hasMatch(v)) {
          return 'Некорректный email';
        }
        return null;
      },
    );
  }
}
