part of '../pages/login_page.dart';

class _PasswordField extends StatefulWidget {
  const _PasswordField();

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
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
