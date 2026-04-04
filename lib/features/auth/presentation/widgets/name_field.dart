import 'package:flutter/material.dart';

class NameField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Имя',
        border: OutlineInputBorder(),
      ),
      textCapitalization: TextCapitalization.words,
      validator: (v) {
        if ((v == null || v.trim().isEmpty)) {
          return 'Введите имя';
        }
        return null;
      },
    );
  }
}
