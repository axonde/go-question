part of '../go_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GoButtonColors — единственная ответственность: палитра кнопки
// Все цвета рассчитываются от одного baseColor через HSL-сдвиги.
// ─────────────────────────────────────────────────────────────────────────────

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

  /// Рассчитывает всю палитру от одного базового цвета [base].
  factory GoButtonColors.fromBaseColor(Color base) {
    final safeBase = base.withValues(alpha: 1.0);

    return GoButtonColors(
      shadowColor: Colors.black,
      borderColor: Colors.black,
      outerGradient: LinearGradient(
        colors: [
          _shiftHSL(safeBase, dH: -13, dL: -0.16),
          _shiftHSL(safeBase, dH: -14, dL: -0.13),
        ],
      ),
      mainGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          _shiftHSL(safeBase, dH: -6, dL: -0.03),
          _shiftHSL(safeBase, dH: -7, dL: -0.03),
        ],
      ),
      innerPanelColor: safeBase,
      innerPanelTopColor: _shiftHSL(safeBase, dL: 0.10),
      textColor: Colors.white,
      textShadowColor: Colors.black.withValues(alpha: 0.9),
      textStrokeColor: Colors.black,
    );
  }

  /// Дефолтная оранжевая кнопка.
  factory GoButtonColors.defaultOrange() =>
      GoButtonColors.fromBaseColor(const Color(0xFFFFC00F));

  GoButtonColors copyWith({
    Color? shadowColor,
    Color? borderColor,
    Gradient? outerGradient,
    Gradient? mainGradient,
    Color? innerPanelColor,
    Color? innerPanelTopColor,
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
