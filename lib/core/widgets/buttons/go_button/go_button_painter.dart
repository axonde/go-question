part of '../go_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// _GoButtonPainter — единственная ответственность: визуальный хром кнопки.
// Контент (текст / иконка / ассет) рендерится отдельно через CustomPaint.child.
// ─────────────────────────────────────────────────────────────────────────────

class _GoButtonPainter extends CustomPainter {
  final GoButtonColors colors;

  const _GoButtonPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;

    double rx(double x) => x * w / 161;
    double ry(double y) => y * h / 108;

    _drawShadow(canvas, w, h, rx, ry);
    _drawOuterGradient(canvas, w, h, rx, ry);
    _drawBorder(canvas, w, h, rx, ry);
    _drawMainGradient(canvas, w, h, rx, ry);
    _drawInnerPanel(canvas, rx, ry);
    _drawInnerPanelTop(canvas, rx, ry);
    _drawHighlight(canvas, rx, ry);
  }

  void _drawShadow(
    Canvas canvas,
    double w,
    double h,
    double Function(double) rx,
    double Function(double) ry,
  ) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, ry(4), w, h),
        Radius.circular(rx(11)),
      ),
      Paint()..color = colors.shadowColor,
    );
  }

  void _drawOuterGradient(
    Canvas canvas,
    double w,
    double h,
    double Function(double) rx,
    double Function(double) ry,
  ) {
    final rect = Rect.fromLTWH(rx(1), ry(1), w - rx(1.5), h - ry(1.5));
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(rx(10))),
      Paint()..shader = colors.outerGradient.createShader(rect),
    );
  }

  void _drawBorder(
    Canvas canvas,
    double w,
    double h,
    double Function(double) rx,
    double Function(double) ry,
  ) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, w, h),
        Radius.circular(rx(11)),
      ),
      Paint()
        ..color = colors.borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = rx(1.5),
    );
  }

  void _drawMainGradient(
    Canvas canvas,
    double w,
    double h,
    double Function(double) rx,
    double Function(double) ry,
  ) {
    final rect = Rect.fromLTWH(rx(1), ry(1), w - rx(2), ry(100));
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(rx(9))),
      Paint()..shader = colors.mainGradient.createShader(rect),
    );
  }

  void _drawInnerPanel(
    Canvas canvas,
    double Function(double) rx,
    double Function(double) ry,
  ) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(rx(7), ry(6), rx(147), ry(88)),
        Radius.circular(rx(6)),
      ),
      Paint()..color = colors.innerPanelColor,
    );
  }

  void _drawInnerPanelTop(
    Canvas canvas,
    double Function(double) rx,
    double Function(double) ry,
  ) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(rx(7), ry(6), rx(147), ry(43)),
        Radius.circular(rx(6)),
      ),
      Paint()..color = colors.innerPanelTopColor,
    );
  }

  void _drawHighlight(
    Canvas canvas,
    double Function(double) rx,
    double Function(double) ry,
  ) {
    canvas.save();
    canvas.translate(rx(146), ry(14));
    canvas.rotate(-45.87 * 3.14159 / 180);
    canvas.drawOval(
      Rect.fromLTWH(-rx(5.69) / 2, -ry(8) / 2, rx(5.69), ry(8)),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.9)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, rx(1)),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GoButtonPainter old) => old.colors != colors;
}
