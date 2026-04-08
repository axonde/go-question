import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';

/// Текст с обводкой в стиле Clash.
/// Используется для заголовков и акцентных элементов.
class ClashStrokeText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final Color strokeColor;
  final double? strokeWidth;
  final List<Shadow>? shadows;
  final int? maxLines;
  final TextOverflow? overflow;

  const ClashStrokeText(
    this.text, {
    super.key,
    required this.fontSize,
    this.fontWeight = FontWeight.bold,
    this.textColor = Colors.white,
    this.strokeColor = Colors.black,
    this.strokeWidth,
    this.shadows,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    const family = 'Clash';
    const fallback = ['Roboto', 'sans-serif'];
    final effectiveStrokeWidth = strokeWidth ?? UiConstants.strokeWidth;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Обводка
        Text(
          text,
          maxLines: maxLines,
          overflow: overflow,
          style: TextStyle(
            fontFamily: family,
            fontFamilyFallback: fallback,
            fontSize: fontSize,
            fontWeight: fontWeight,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = effectiveStrokeWidth
              ..color = strokeColor,
          ),
        ),
        // Основной текст
        Text(
          text,
          maxLines: maxLines,
          overflow: overflow,
          style: TextStyle(
            fontFamily: family,
            fontFamilyFallback: fallback,
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
            shadows: shadows,
          ),
        ),
      ],
    );
  }
}
