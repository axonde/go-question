import 'package:flutter/material.dart';
import 'package:go_question/features/auth/presentation/validators/auth_field_validators.dart';

class NameField extends StatelessWidget {
  final TextEditingController controller;

  const NameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Имя',
        border: OutlineInputBorder(),
      ),
      textCapitalization: TextCapitalization.words,
      validator: AuthFieldValidators.name,
    );
  }
}
