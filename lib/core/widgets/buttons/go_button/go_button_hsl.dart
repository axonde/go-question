part of '../go_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HSL helper — единственная ответственность: сдвиг цвета в пространстве HSL
// ─────────────────────────────────────────────────────────────────────────────

Color _shiftHSL(Color color, {double dH = 0, double dL = 0, double dS = 0}) {
  final hsl = HSLColor.fromColor(color);

  double newHue = (hsl.hue + dH) % 360;
  if (newHue < 0) newHue += 360;

  return HSLColor.fromAHSL(
    1.0,
    newHue,
    (hsl.saturation + dS).clamp(0.0, 1.0),
    (hsl.lightness + dL).clamp(0.05, 0.95),
  ).toColor();
}
