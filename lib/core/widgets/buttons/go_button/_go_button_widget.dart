part of '../go_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GoButton — единственная ответственность: анимация нажатия + управление
// размером. Делегирует рисование → _GoButtonPainter, палитру → GoButtonColors.
// ─────────────────────────────────────────────────────────────────────────────

class GoButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String? text;
  final IconData? icon;
  final double iconSizeFactor;

  // Размеры
  final double? widthFactor; // доля от родителя (0.0 – 1.0)
  final double? width;       // фиксированная ширина
  final double? height;      // фиксированная высота
  final double aspectRatio;  // соотношение сторон (по умолчанию 161/108)

  // Цвета — если задан baseColor, остальные рассчитываются автоматически;
  // конкретный цвет переопределяет расчётное значение.
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
  }) : assert(text != null || icon != null, 'Нужен text или icon');

  @override
  State<GoButton> createState() => _GoButtonState();
}

class _GoButtonState extends State<GoButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.forward();
  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
    widget.onPressed();
  }
  void _onTapCancel() => _controller.reverse();

  GoButtonColors _buildColors() {
    final base = widget.baseColor ?? const Color(0xFFFFC00F);
    return GoButtonColors.fromBaseColor(base).copyWith(
      shadowColor: widget.shadowColor,
      borderColor: widget.borderColor,
      outerGradient: widget.outerGradient,
      mainGradient: widget.mainGradient,
      innerPanelColor: widget.innerPanelColor,
      innerPanelTopColor: widget.innerPanelTopColor,
      textColor: widget.textColor,
      textShadowColor: widget.textShadowColor,
      textStrokeColor: widget.textStrokeColor,
    );
  }

  Widget _content(GoButtonColors colors) => CustomPaint(
        painter: _GoButtonPainter(
          colors: colors,
          text: widget.text,
          icon: widget.icon,
          iconSizeFactor: widget.iconSizeFactor,
        ),
      );

  Widget _sized(GoButtonColors colors) {
    final content = _content(colors);

    if (widget.width != null && widget.height != null) {
      return SizedBox(width: widget.width, height: widget.height, child: content);
    }
    if (widget.width != null) {
      return SizedBox(
        width: widget.width,
        child: AspectRatio(aspectRatio: widget.aspectRatio, child: content),
      );
    }
    if (widget.height != null) {
      return SizedBox(
        height: widget.height,
        child: AspectRatio(aspectRatio: widget.aspectRatio, child: content),
      );
    }
    if (widget.widthFactor != null) {
      return FractionallySizedBox(
        widthFactor: widget.widthFactor,
        child: AspectRatio(aspectRatio: widget.aspectRatio, child: content),
      );
    }
    return AspectRatio(aspectRatio: widget.aspectRatio, child: content);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: ScaleTransition(scale: _scale, child: _sized(_buildColors())),
      );
}
