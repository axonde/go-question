import 'package:flutter/material.dart';

class GoButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const GoButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: AspectRatio(
        aspectRatio: 161 / 108,
        child: CustomPaint(painter: _GoButtonPainter()),
      ),
    );
  }
}

class _GoButtonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Вспомогательная функция для относительных координат
    double rx(double x) => x * w / 161;
    double ry(double y) => y * h / 108;

    // 1. Тень (box-shadow: 0px 2px 0px 1px black) [checked]
    final shadowRect = Rect.fromLTWH(0, ry(2), w, h);
    final shadowPaint = Paint()..color = Colors.black;
    canvas.drawRRect(
      RRect.fromRectAndRadius(shadowRect, Radius.circular(rx(11))),
      shadowPaint,
    );

    // 2. Внешний фон кнопки (тёмный градиент)
    final outerRect = Rect.fromLTWH(0, 0, w, h);
    final outerGradient = LinearGradient(
      begin: Alignment(-0.99, 0.0),
      end: Alignment(1.0, 0.0),
      colors: [Color(0xFFBF6700), Color(0xFFCC6800)],
    ).createShader(outerRect);
    final outerPaint = Paint()..shader = outerGradient;
    canvas.drawRRect(
      RRect.fromRectAndRadius(outerRect, Radius.circular(rx(11))),
      outerPaint,
    );

    // 3. Внешняя чёрная обводка (border: 1.2px solid black)
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = rx(1.2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(outerRect, Radius.circular(rx(11))),
      borderPaint,
    );

    // 4. Основной яркий градиент (Rectangle 8)
    final rect8Rect = Rect.fromLTWH(0, 0, w, ry(100));
    final gradient8 = LinearGradient(
      begin: Alignment(-0.8, 0.2),
      end: Alignment(0.8, -0.2),
      colors: [Color(0xFFFFA500), Color(0xFFFFA000)],
    ).createShader(rect8Rect);
    final paint8 = Paint()..shader = gradient8;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect8Rect, Radius.circular(rx(10))),
      paint8,
    );

    // 5. Внутренний жёлтый прямоугольник (Rectangle 10)
    final rect10Rect = Rect.fromLTWH(rx(6), ry(5), rx(149), ry(90));
    final paint10 = Paint()..color = Color(0xFFFFC00F);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect10Rect, Radius.circular(rx(6))),
      paint10,
    );

    // 6. Верхняя половина (Rectangle 11)
    final rect11Rect = Rect.fromLTWH(rx(6), ry(5), rx(149), ry(44));
    final paint11 = Paint()..color = Color(0xFFFFCD41);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect11Rect, Radius.circular(rx(6))),
      paint11,
    );

    // 8. Блик (Ellipse 1) – белое пятно, повёрнутое
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

    // 9. Текст "Поиск" с тенью и обводкой
    final textSpan = TextSpan(
      text: 'Поиск',
      style: TextStyle(
        fontFamily: 'Clash',
        fontSize: rx(24),
        fontWeight: FontWeight.w400,
        color: Colors.white,
        shadows: [
          Shadow(
            offset: Offset(0, ry(1.43615)),
            blurRadius: 0,
            color: Colors.black.withOpacity(0.9),
          ),
        ],
        // Обводка через foreground - не работает в Canvas напрямую. Нарисуем дважды: сначала обводку, потом текст.
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: rx(84));
    // Позиция left:38, top:39
    final textOffset = Offset(rx(43), ry(36));
    // Рисуем обводку (толщина 0.86)
    final strokeTextSpan = TextSpan(
      text: 'Поиск',
      style: TextStyle(
        fontFamily: 'Clash',
        fontSize: rx(24),
        fontWeight: FontWeight.w400,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = rx(0.86169)
          ..color = Colors.black,
      ),
    );
    final strokePainter = TextPainter(
      text: strokeTextSpan,
      textDirection: TextDirection.ltr,
    );
    strokePainter.layout(maxWidth: rx(84));
    strokePainter.paint(canvas, textOffset);
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

