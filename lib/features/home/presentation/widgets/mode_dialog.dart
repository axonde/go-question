import 'package:flutter/material.dart';

/// Диалог кнопки 2.
class ModeDialog extends StatelessWidget {
  const ModeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Кнопка 2 — диалог'),
      content: const Text('[содержимое диалога]'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Закрыть'),
        ),
      ],
    );
  }
}
