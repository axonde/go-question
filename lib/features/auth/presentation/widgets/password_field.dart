import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField();

  @override
  State<PasswordField> createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscured,
      decoration: InputDecoration(
        labelText: 'Пароль',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () => setState(() => isObscured = !isObscured),
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
