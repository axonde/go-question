import 'package:flutter/material.dart';
import 'package:go_question/features/auth/presentation/validators/auth_field_validators.dart';

class EmailField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const EmailField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
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
