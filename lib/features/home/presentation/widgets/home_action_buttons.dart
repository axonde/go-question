import 'package:flutter/material.dart';

/// Две кнопки действия в нижней части главного экрана.
class HomeActionButtons extends StatelessWidget {
  final VoidCallback onBattleSheetTap;
  final VoidCallback onModeDialogTap;

  const HomeActionButtons({
    super.key,
    required this.onBattleSheetTap,
    required this.onModeDialogTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: onBattleSheetTap,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('Кнопка 1 (снизу)'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onModeDialogTap,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('Кнопка 2 (диалог)'),
          ),
        ],
      ),
    );
  }
}
