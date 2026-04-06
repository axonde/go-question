import 'package:flutter/material.dart';
import 'package:go_question/features/auth/presentation/validators/auth_field_validators.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordField({super.key, required this.controller});

  @override
  State<PasswordField> createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: 'Пароль',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            isObscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () => setState(() => isObscure = !isObscure),
        ),
      ),
      validator: AuthFieldValidators.password,
    );
  }
}
