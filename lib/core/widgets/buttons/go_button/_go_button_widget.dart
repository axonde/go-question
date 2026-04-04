part of '../go_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GoButton — единственная ответственность: палитра + размер + компоновка.
// Анимация нажатия делегирована → Pressable (core/widgets/pressable.dart).
// ─────────────────────────────────────────────────────────────────────────────

class GoButton extends StatelessWidget {
  final VoidCallback onPressed;

  // Контент (одно из трёх обязательно)
  final String? text;
  final IconData? icon;
  final String? assetPath;

  /// Размер текста. null → пропорциональный дефолт: 24 × ширина / 161.
  final double? fontSize;
  final double iconSizeFactor;

  // Размеры
  final double? widthFactor;
  final double? width;
  final double? height;
  final double aspectRatio;

  // Цвета
  final Color? baseColor;
  final Color? shadowColor;
  final Color? borderColor;
  final Gradient? outerGradient;
  final Gradient? mainGradient;
  final Color? innerPanelColor;
  final Color? innerPanelTopColor;
  final Color? textColor;
  final Color? textShadowColor;
  final Color? textStrokeColor;

  const GoButton({
    super.key,
    required this.onPressed,
    this.text,
    this.icon,
    this.assetPath,
    this.fontSize,
    this.iconSizeFactor = 0.4,
    this.widthFactor = 0.8,
    this.width,
    this.height,
    this.aspectRatio = 161 / 108,
    this.baseColor,
    this.shadowColor,
    this.borderColor,
    this.outerGradient,
    this.mainGradient,
    this.innerPanelColor,
    this.innerPanelTopColor,
    this.textColor,
    this.textShadowColor,
    this.textStrokeColor,
  }) : assert(
          text != null || icon != null || assetPath != null,
          'GoButton требует text, icon или assetPath',
        );

  GoButtonColors _buildColors() {
    final base = baseColor ?? const Color(0xFFFFC00F);
    return GoButtonColors.fromBaseColor(base).copyWith(
      shadowColor: shadowColor,
      borderColor: borderColor,
      outerGradient: outerGradient,
      mainGradient: mainGradient,
      innerPanelColor: innerPanelColor,
      innerPanelTopColor: innerPanelTopColor,
      textColor: textColor,
      textShadowColor: textShadowColor,
      textStrokeColor: textStrokeColor,
    );
  }

  Widget _content(GoButtonColors colors) => CustomPaint(
        painter: _GoButtonPainter(colors: colors),
        child: _GoButtonContent(
          text: text,
          icon: icon,
          assetPath: assetPath,
          fontSize: fontSize,
          iconSizeFactor: iconSizeFactor,
          colors: colors,
        ),
      );

  Widget _sized(GoButtonColors colors) {
    final content = _content(colors);

    if (width != null && height != null) {
      return SizedBox(width: width, height: height, child: content);
    }
    if (width != null) {
      return SizedBox(
        width: width,
        child: AspectRatio(aspectRatio: aspectRatio, child: content),
      );
    }
    if (height != null) {
      return SizedBox(
        height: height,
        child: AspectRatio(aspectRatio: aspectRatio, child: content),
      );
    }
    if (widthFactor != null) {
      return FractionallySizedBox(
        widthFactor: widthFactor,
        child: AspectRatio(aspectRatio: aspectRatio, child: content),
      );
    }
    return AspectRatio(aspectRatio: aspectRatio, child: content);
  }

  @override
  Widget build(BuildContext context) => Pressable(
        onTap: onPressed,
        child: _sized(_buildColors()),
      );
}
