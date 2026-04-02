import 'package:flutter/material.dart';

class GoButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double height;
  final double fontSize;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const GoButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.foregroundColor,
    this.width = 161,
    this.height = 108,
    this.fontSize = 24,
    this.borderRadius,
    this.padding,
    this.textStyle,
  });

  @override
  State<GoButton> createState() => _GoButtonState();
}

class _GoButtonState extends State<GoButton> {
  final bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = widget.backgroundColor;
    final effectiveForegroundColor = widget.foregroundColor ?? Colors.white;

    final button = ElevatedButton(
      onPressed: isLoading ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: effectiveBackgroundColor,
        foregroundColor: effectiveForegroundColor,
        fixedSize: widget.width != null
            ? Size(widget.width!, widget.height)
            : null,
        minimumSize: widget.width != null
            ? Size(widget.width!, widget.height)
            : null,
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        ),
        textStyle:
            widget.textStyle ??
            TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.w600, value)),
      ),
      child: isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  effectiveForegroundColor,
                ),
              ),
            )
          : Row(mainAxisSize: MainAxisSize.min, children: [Text(widget.text)]),
    );

    if (widget.width == null) {
      return button;
    } else {
      return SizedBox(width: widget.width, child: button);
    }
  }
}
