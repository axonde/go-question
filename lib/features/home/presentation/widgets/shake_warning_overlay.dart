import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/buttons/go_button/gq_close_button.dart';
import 'package:go_question/core/widgets/text/clash_stroke_text.dart';

class ShakeWarningOverlay extends StatelessWidget {
  final VoidCallback onClose;

  const ShakeWarningOverlay({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.popupOutBackground,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: UiConstants.gap * 2),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // WARNING BOX
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.stroke, width: 2),
                  borderRadius: BorderRadius.circular(
                    UiConstants.borderRadius * 2,
                  ),
                ),
                padding: const EdgeInsets.all(UiConstants.gap * 2),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClashStrokeText('Братишка не тряси)', fontSize: 28),
                    SizedBox(height: UiConstants.gap),
                    ClashStrokeText(
                      'Причина тряски???',
                      fontSize: 20,
                      textColor: AppColors.secondary,
                    ),
                  ],
                ),
              ),

              // CLOSE BUTTON
              Positioned(
                top: -UiConstants.gap * 1.5,
                right: -UiConstants.gap * 1.5,
                child: GqCloseButton(onTap: onClose),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
