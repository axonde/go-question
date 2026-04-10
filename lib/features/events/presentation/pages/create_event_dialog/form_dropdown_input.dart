part of '../create_event_dialog.dart';

class _FormDropdownInput<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T)? itemLabelBuilder;

  const _FormDropdownInput({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.itemLabelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UiConstants.boxUnit),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        isExpanded: true,
        dropdownColor: const Color(0xFF1A4D84),
        style: const TextStyle(
          color: Colors.white,
          fontFamily: EventTexts.fontClash,
          fontFamilyFallback: EventTexts.fontFallback,
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
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(itemLabelBuilder?.call(item) ?? item.toString()),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
