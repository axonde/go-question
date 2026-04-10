import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';

class GqDialogPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets insetPadding;
  final EdgeInsetsGeometry contentPadding;
  final double maxWidth;
  final double maxHeight;

  const GqDialogPanel({
    super.key,
    required this.child,
    this.insetPadding = const EdgeInsets.all(UiConstants.boxUnit * 2),
    this.contentPadding = const EdgeInsets.all(UiConstants.boxUnit * 2),
    this.maxWidth = 560,
    this.maxHeight = 760,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: insetPadding,
      child: MediaQuery.removeViewInsets(
        context: context,
        removeBottom: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(UiConstants.borderRadius * 6),
              border: Border.all(
                color: AppColors.lightStroke,
                width: UiConstants.boxUnit,
              ),
              boxShadow: const [
                BoxShadow(color: Color(0x88000000), offset: Offset(0, 6)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                UiConstants.borderRadius * 4.5,
              ),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/background/background.webp',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ColoredBox(
                  color: const Color(0x99104A86),
                  child: Padding(padding: contentPadding, child: child),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
