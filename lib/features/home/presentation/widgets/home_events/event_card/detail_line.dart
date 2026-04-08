part of '../../home_events.dart';

class _DetailLine extends StatelessWidget {
  final String label;
  final String value;

  const _DetailLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UiConstants.boxUnit * 0.5),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontFamily: EventTexts.fontClash,
                fontFamilyFallback: EventTexts.fontFallback,
                fontSize: UiConstants.textSize * 0.78,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontFamily: EventTexts.fontClash,
                fontFamilyFallback: EventTexts.fontFallback,
                fontSize: UiConstants.textSize * 0.78,
                color: Color(0xFFBFD7F0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
