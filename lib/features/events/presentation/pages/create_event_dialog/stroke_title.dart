part of '../create_event_dialog.dart';

class _StrokeTitle extends StatelessWidget {
  final String text;

  const _StrokeTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontFamily: EventTexts.fontClash,
            fontFamilyFallback: EventTexts.fontFallback,
            fontSize: UiConstants.textSize * 1.5,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = UiConstants.strokeWidth
              ..color = Colors.black,
          ),
        ),
        Text(
          text,
          style: const TextStyle(
            fontFamily: EventTexts.fontClash,
            fontFamilyFallback: EventTexts.fontFallback,
            fontSize: UiConstants.textSize * 1.5,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [Shadow(offset: Offset(0, UiConstants.textShadowOffsetY))],
          ),
        ),
      ],
    );
  }
}
