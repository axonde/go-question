import 'package:flutter/material.dart';

class GoButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double height;
  final double fontSize;
  final bool isLoading;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final ButtonStyle? buttonStyle;

  const GoButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height = 48,
    this.fontSize = 16,
    this.isLoading = false,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.buttonStyle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor;
    final effectiveForegroundColor = foregroundColor ?? Colors.white;

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style:
          buttonStyle ??
          ElevatedButton.styleFrom(
            backgroundColor: effectiveBackgroundColor,
            foregroundColor: effectiveForegroundColor,
            fixedSize: width != null ? Size(width!, height) : null,
            minimumSize: width != null ? Size(width!, height) : null,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(12),
            ),
            textStyle:
                textStyle ??
                TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
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
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[icon!, const SizedBox(width: 8)],
                Text(text),
              ],
            ),
    );

    if (width == null) {
      return button;
    } else {
      return SizedBox(width: width, child: button);
    }
  }
}
