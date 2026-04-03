part of '../auth_screen.dart';

class _AuthNameField extends StatelessWidget {
  final TextEditingController controller;

  const _AuthNameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Имя',
        border: OutlineInputBorder(),
      ),
      textCapitalization: TextCapitalization.words,
      validator: (v) {
        final isLogin =
            (context.findAncestorStateOfType<_AuthScreenState>()?._isLogin) ??
            true;
        if (!isLogin && (v == null || v.trim().isEmpty)) {
          return 'Введите имя';
        }
        return null;
      },
    );
  }
}
