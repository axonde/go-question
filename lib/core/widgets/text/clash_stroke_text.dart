import 'package:flutter/material.dart';

/// Текст со стилизацией Clash Royale (белая заливка, черная обводка).
class ClashStrokeText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final Color strokeColor;
  final double strokeWidth;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final List<Shadow>? shadows;

  const ClashStrokeText(
    this.text, {
    super.key,
    required this.fontSize,
    this.textColor = Colors.white,
    this.strokeColor = Colors.black,
    this.strokeWidth = 3.0,
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.overflow,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Обводка
        Text(
          text,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          style: TextStyle(
            fontFamily: 'Clash',
            fontFamilyFallback: const ['Roboto', 'sans-serif'],
            fontSize: fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        // Внутренняя заливка
        Text(
          text,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          style: TextStyle(
            fontFamily: 'Clash',
            fontFamilyFallback: const ['Roboto', 'sans-serif'],
            fontSize: fontSize,
            color: textColor,
            shadows: shadows,
          ),
        ),
      ],
    );
  }
}
