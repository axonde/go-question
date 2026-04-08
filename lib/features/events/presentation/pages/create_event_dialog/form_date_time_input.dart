part of '../create_event_dialog.dart';

class _FormDateTimeInput extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _FormDateTimeInput({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UiConstants.boxUnit),
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0x330A2540),
            borderRadius: BorderRadius.circular(UiConstants.borderRadius * 3),
            border: Border.all(color: const Color(0xFF6EA3D4)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UiConstants.boxUnit * 1.25,
              vertical: UiConstants.boxUnit,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFFE8F1FF),
                    fontFamily: EventTexts.fontClash,
                    fontFamilyFallback: EventTexts.fontFallback,
                    fontSize: UiConstants.textSize * 0.75,
                  ),
                ),
                const SizedBox(height: UiConstants.boxUnit * 0.5),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: EventTexts.fontClash,
                    fontFamilyFallback: EventTexts.fontFallback,
                    fontSize: UiConstants.textSize * 0.85,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
