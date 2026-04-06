import 'package:flutter/material.dart';
import 'package:go_question/features/auth/presentation/validators/auth_field_validators.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

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
      validator: AuthFieldValidators.email,
    );
  }
}
