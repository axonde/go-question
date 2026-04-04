import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
        if (!_emailRegex.hasMatch(v)) {
          return 'Некорректный email';
        }
        return null;
      },
    );
  }
}
