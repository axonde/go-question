part of '../go_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// _GoButtonContent — единственная ответственность: контент внутри кнопки.
// Размещается как child CustomPaint → поверх нарисованного хрома.
// ─────────────────────────────────────────────────────────────────────────────

class _GoButtonContent extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final String? assetPath;

  /// Явный размер шрифта. null → пропорциональный дефолт: 24 × w / 161.
  final double? fontSize;
  final double iconSizeFactor;
  final GoButtonColors colors;

  const _GoButtonContent({
    required this.colors,
    this.text,
    this.icon,
    this.assetPath,
    this.fontSize,
    this.iconSizeFactor = 0.4,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        // Отступ совпадает с границами innerPanel из _GoButtonPainter:
        // горизонталь rx(7) = 7/161*w, вертикаль ry(6) = 6/108*h
        final hPad = w * 7 / 161;
        final vPad = h * 6 / 108;

        if (text != null) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: _ButtonText(
                  text: text!,
                  fontSize: fontSize ?? w * 24 / 161,
                  shadowOffsetY: h * 2 / 108,
                  colors: colors,
                ),
              ),
            ),
          );
        }
        if (assetPath != null) {
          final size = h * iconSizeFactor;
          return Center(
            child: _ButtonAsset(assetPath: assetPath!, size: size),
          );
        }
        if (icon != null) {
          return Center(
            child: _ButtonIcon(
              icon: icon!,
              size: h * iconSizeFactor,
              strokeWidth: w * 1.2 / 161,
              shadowOffsetY: h * 2 / 108,
              colors: colors,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ButtonText — игровой текст (белый + чёрная обводка + тень).
// ─────────────────────────────────────────────────────────────────────────────

class _ButtonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final double shadowOffsetY;
  final GoButtonColors colors;

  const _ButtonText({
    required this.text,
    required this.fontSize,
    required this.shadowOffsetY,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    const family = 'Clash';
    const fallback = ['Roboto', 'sans-serif'];
    final strokeWidth =
        fontSize * 2 / 24; // пропорционально дефолту rx(2)/rx(24)

    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: family,
            fontFamilyFallback: fallback,
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = colors.textStrokeColor,
          ),
        ),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: family,
            fontFamilyFallback: fallback,
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            color: colors.textColor,
            shadows: [
              Shadow(
                offset: Offset(0, shadowOffsetY),
                color: colors.textShadowColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ButtonAsset — изображение из ассетов внутри кнопки.
// ─────────────────────────────────────────────────────────────────────────────

class _ButtonAsset extends StatelessWidget {
  final String assetPath;
  final double size;

  const _ButtonAsset({required this.assetPath, required this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ButtonIcon — Material-иконка внутри кнопки (белая + обводка + тень).
// ─────────────────────────────────────────────────────────────────────────────

class _ButtonIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final double strokeWidth;
  final double shadowOffsetY;
  final GoButtonColors colors;

  const _ButtonIcon({
    required this.icon,
    required this.size,
    required this.strokeWidth,
    required this.shadowOffsetY,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(icon, size: size, color: colors.textStrokeColor),
        Icon(
          icon,
          size: size,
          color: colors.textColor,
          shadows: [
            Shadow(
              offset: Offset(0, shadowOffsetY),
              color: colors.textShadowColor,
            ),
          ],
        ),
      ],
    );
  }
}
