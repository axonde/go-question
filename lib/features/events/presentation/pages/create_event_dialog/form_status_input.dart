part of '../create_event_dialog.dart';

class _FormStatusInput extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const _FormStatusInput({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UiConstants.boxUnit),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        dropdownColor: const Color(0xFF1A4D84),
        style: const TextStyle(
          color: Colors.white,
          fontFamily: EventTexts.fontClash,
          fontFamilyFallback: EventTexts.fontFallback,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFFE8F1FF),
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
        ),
        items: EventConstants.statuses.map((status) {
          return DropdownMenuItem<String>(
            value: status,
            child: Text(EventPresentationUtils.statusLabel(status)),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
    );
  }
}
