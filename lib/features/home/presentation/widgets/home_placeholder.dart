import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';

/// Центральная заглушка главного экрана.
class HomePlaceholder extends StatelessWidget {
  final bool hintsEnabled;
  final bool compactModeEnabled;

  const HomePlaceholder({
    super.key,
    this.hintsEnabled = true,
    this.compactModeEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: hintsEnabled ? 1 : 0.3,
        child: Padding(
          padding: EdgeInsets.all(
            compactModeEnabled ? UiConstants.boxUnit : UiConstants.boxUnit * 2,
          ),
          child: const Text(
            '[заглушка]',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
