part of '../create_event_dialog.dart';

class _FormInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;
  final FormFieldValidator<String>? validator;

  const _FormInput({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UiConstants.boxUnit),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: EventTexts.fontClash,
          fontFamilyFallback: EventTexts.fontFallback,
          fontSize: UiConstants.textSize * 0.8,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(
            color: Color(0xFFE8F1FF),
            fontFamily: EventTexts.fontClash,
            fontFamilyFallback: EventTexts.fontFallback,
          ),
          hintStyle: const TextStyle(
            color: Color(0xFF9FB4CC),
            fontFamily: EventTexts.fontClash,
            fontFamilyFallback: EventTexts.fontFallback,
          ),
          filled: true,
          fillColor: const Color(0x330A2540),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(UiConstants.borderRadius * 3),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(UiConstants.borderRadius * 3),
            borderSide: const BorderSide(color: Color(0xFF6EA3D4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(UiConstants.borderRadius * 3),
            borderSide: const BorderSide(color: Color(0xFFB3D8FF)),
          ),
        ),
      ),
    );
  }
}
