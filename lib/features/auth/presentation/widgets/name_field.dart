import 'package:flutter/material.dart';
import 'package:go_question/features/auth/presentation/validators/auth_field_validators.dart';

class NameField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const NameField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      textInputAction: TextInputAction.done,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      onFieldSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: const InputDecoration(
        labelText: 'Никнейм',
        border: OutlineInputBorder(),
      ),
      validator: AuthFieldValidators.nickname,
    );
  }
}
