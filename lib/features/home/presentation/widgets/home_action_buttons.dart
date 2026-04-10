import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/home_ui_constants.dart';
import 'package:go_question/core/localization/presentation/localization_context_extension.dart';
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
    final l10n = context.l10n;
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
                      text: l10n.homeActionSearch,
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
                      text: l10n.homeActionNew,
                      baseColor: AppColors.primary,
                      mainGradient: const LinearGradient(
                        colors: [
                          HomeUiConstants.createButtonMainStart,
                          HomeUiConstants.createButtonMainEnd,
                        ],
                      ),
                      outerGradient: const LinearGradient(
                        colors: [
                          HomeUiConstants.createButtonOuterStart,
                          HomeUiConstants.createButtonOuterEnd,
                        ],
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
