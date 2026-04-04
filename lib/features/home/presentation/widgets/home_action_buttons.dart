import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GoButton(
            width: UiConstants.boxUnit * 20,
            height: UiConstants.boxUnit * 12.5,
            onPressed: onBattleSheetTap,
            text: 'Поиск',
            baseColor: Color(0xFFFFC00F),
          ),
          const SizedBox(width: UiConstants.middlePadding * 2),
          GoButton(
            width: UiConstants.boxUnit * 20,
            height: UiConstants.boxUnit * 12.5,
            onPressed: onModeDialogTap,
            baseColor: Color(0xFF33B4FF),
            mainGradient: LinearGradient(
              colors: [Color(0xFF0092F5), Color(0xFF008FF2)],
            ),
            outerGradient: LinearGradient(
              colors: [Color(0xFF005BC0), Color(0xFF0055B8)],
            ),
            text: 'Новое',
          ),
        ],
      ),
    );
  }
}
