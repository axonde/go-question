import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/event_texts.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';

/// Две кнопки действия в нижней части главного экрана.
class HomeActionButtons extends StatelessWidget {
  final VoidCallback onBattleSheetTap;
  final VoidCallback onCreateEventTap;

  const HomeActionButtons({
    super.key,
    required this.onBattleSheetTap,
    required this.onCreateEventTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final h = constraints.maxHeight - UiConstants.verticalPadding * 2;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UiConstants.horizontalPadding * 2,
            vertical: UiConstants.verticalPadding,
          ),
          child: Row(
            spacing: UiConstants.boxUnit,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: UiConstants.leftPadding * 2,
                    right: UiConstants.rightPadding / 2,
                  ),
                  child: LayoutBuilder(
                    builder: (_, c) => GQButton(
                      onPressed: onBattleSheetTap,
                      text: EventTexts.buttonSearch,
                      baseColor: AppColors.secondary,
                      width: c.maxWidth,
                      height: h,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: UiConstants.leftPadding / 2,
                    right: UiConstants.rightPadding * 2,
                  ),
                  child: LayoutBuilder(
                    builder: (_, c) => GQButton(
                      onPressed: onCreateEventTap,
                      text: EventTexts.buttonNew,
                      baseColor: AppColors.primary,
                      mainGradient: const LinearGradient(
                        colors: [Color(0xFF0092F5), Color(0xFF008FF2)],
                      ),
                      outerGradient: const LinearGradient(
                        colors: [Color(0xFF005BC0), Color(0xFF0055B8)],
                      ),
                      width: c.maxWidth,
                      height: h,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
