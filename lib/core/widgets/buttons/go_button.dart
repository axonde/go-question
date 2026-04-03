import 'package:flutter/material.dart';

class GoButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final GoButtonColors colors;

  const GoButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: AspectRatio(
        aspectRatio: 161 / 108,
        child: CustomPaint(
          painter: _GoButtonPainter(colors: colors, text: text),
        ),
      ),
    );
  }
}

class _GoButtonPainter extends CustomPainter {
  final GoButtonColors colors;
  final String text;

  const _GoButtonPainter({
    required this.colors,
    required this.text,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    if (w <= 0 || h <= 0) return; // защита от нулевого размера

    double rx(double x) => x * w / 161;
    double ry(double y) => y * h / 108;

    // ---- 1. Тень ----
    final shadowRect = Rect.fromLTWH(0, ry(2), w, h);
    canvas.drawRRect(
      RRect.fromRectAndRadius(shadowRect, Radius.circular(rx(11))),
      Paint()..color = colors.shadowColor,
    );

    // ---- 2. Основной фон (тёмный градиент) ----
    final outerRect = Rect.fromLTWH(0, 0, w, h);
    final outerPaint = Paint()
      ..shader = colors.outerGradient.createShader(outerRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(outerRect, Radius.circular(rx(11))),
      outerPaint,
    );

    // ---- 3. Внешняя обводка ----
    final borderPaint = Paint()
      ..color = colors.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = rx(1.2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(outerRect, Radius.circular(rx(11))),
      borderPaint,
    );

    // ---- 4. Яркий градиент (Rectangle 8) ----
    final rect8Rect = Rect.fromLTWH(0, 0, w, ry(100));
    final paint8 = Paint()
      ..shader = colors.mainGradient.createShader(rect8Rect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect8Rect, Radius.circular(rx(10))),
      paint8,
    );

    // ---- 5. Внутренняя жёлтая панель (Rectangle 10) ----
    final rect10Rect = Rect.fromLTWH(rx(6), ry(5), rx(149), ry(90));
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect10Rect, Radius.circular(rx(6))),
      Paint()..color = colors.innerPanelColor,
    );

    // ---- 6. Верхняя половина панели (Rectangle 11) ----
    final rect11Rect = Rect.fromLTWH(rx(6), ry(5), rx(149), ry(44));
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect11Rect, Radius.circular(rx(6))),
      Paint()..color = colors.innerPanelTopColor,
    );

    // ---- 8. Блик (Ellipse 1) ----
    canvas.save();
    canvas.translate(rx(148), ry(12));
    canvas.rotate(-45.87 * 3.14159 / 180);
    final ellipsePaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, rx(1));
    canvas.drawOval(
      Rect.fromLTWH(-rx(5.69) / 2, -ry(8) / 2, rx(5.69), ry(8)),
      ellipsePaint,
    );
    canvas.restore();

    // ========== 10. ТЕКСТ – ЦЕНТРИРОВАННЫЙ И ВИДИМЫЙ ==========
    // Используем стандартный шрифт на случай, если 'Clash' не загружен
    final textStyle = TextStyle(
      fontFamily: 'Clash',
      fontSize: rx(24),
      fontWeight: FontWeight.w400,
      color: colors.textColor,
      shadows: [
        Shadow(
          offset: Offset(0, ry(1.43615)),
          blurRadius: 0,
          color: colors.textShadowColor,
        ),
      ],
      // fallback на системный шрифт
      fontFamilyFallback: ['Roboto', 'sans-serif'],
    );

    final strokeStyle = TextStyle(
      fontFamily: 'Clash',
      fontSize: rx(24),
      fontWeight: FontWeight.w400,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = rx(0.86169)
        ..color = colors.textStrokeColor,
      fontFamilyFallback: ['Roboto', 'sans-serif'],
    );

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
    );
    // Ограничиваем ширину – отступы по краям (20px в исходных координатах)
    final maxTextWidth = w - rx(20);
    textPainter.layout(maxWidth: maxTextWidth > 0 ? maxTextWidth : w);

    final strokePainter = TextPainter(
      text: TextSpan(text: text, style: strokeStyle),
      textDirection: TextDirection.ltr,
    );
    strokePainter.layout(maxWidth: maxTextWidth > 0 ? maxTextWidth : w);

    // Центрируем
    final centerX = (w - textPainter.width) / 2;
    final centerY = (h - textPainter.height) / 2;
    final textOffset = Offset(centerX, centerY);

    strokePainter.paint(canvas, textOffset);
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant _GoButtonPainter oldDelegate) {
    return oldDelegate.colors != colors || oldDelegate.text != text;
  }
}

class GoButtonColors {
  final Color shadowColor;
  final Color borderColor;
  final Gradient outerGradient;
  final Gradient mainGradient;
  final Color innerPanelColor;
  final Color innerPanelTopColor;
  final Color textColor;
  final Color textShadowColor;
  final Color textStrokeColor;

  const GoButtonColors({
    required this.shadowColor,
    required this.borderColor,
    required this.outerGradient,
    required this.mainGradient,
    required this.innerPanelColor,
    required this.innerPanelTopColor,
    required this.textColor,
    required this.textShadowColor,
    required this.textStrokeColor,
  });

  // Можно добавить фабричный конструктор для стандартной темы
  factory GoButtonColors.standard() {
    return GoButtonColors(
      shadowColor: Colors.black,
      borderColor: Colors.black,
      outerGradient: LinearGradient(
        begin: Alignment(-0.99, 0.0),
        end: Alignment(1.0, 0.0),
        colors: [Color(0xFFBF6700), Color(0xFFCC6800)],
      ),
      mainGradient: LinearGradient(
        begin: Alignment(-0.8, 0.2),
        end: Alignment(0.8, -0.2),
        colors: [Color(0xFFFFA500), Color(0xFFFFA000)],
      ),
      innerPanelColor: Color(0xFFFFC00F),
      innerPanelTopColor: Color(0xFFFFCD41),
      textColor: Colors.white,
      textShadowColor: Colors.black.withOpacity(0.9),
      textStrokeColor: Colors.black,
    );
  }

  // Метод для создания копии с изменениями (удобно для кастомизации)
  GoButtonColors copyWith({
    Color? shadowColor,
    Color? borderColor,
    Gradient? outerGradient,
    Gradient? mainGradient,
    Color? innerPanelColor,
    Color? innerPanelTopColor,
    Color? line3Color,
    Color? line4Color,
    Color? textColor,
    Color? textShadowColor,
    Color? textStrokeColor,
  }) {
    return GoButtonColors(
      shadowColor: shadowColor ?? this.shadowColor,
      borderColor: borderColor ?? this.borderColor,
      outerGradient: outerGradient ?? this.outerGradient,
      mainGradient: mainGradient ?? this.mainGradient,
      innerPanelColor: innerPanelColor ?? this.innerPanelColor,
      innerPanelTopColor: innerPanelTopColor ?? this.innerPanelTopColor,
      textColor: textColor ?? this.textColor,
      textShadowColor: textShadowColor ?? this.textShadowColor,
      textStrokeColor: textStrokeColor ?? this.textStrokeColor,
    );
  }
}
