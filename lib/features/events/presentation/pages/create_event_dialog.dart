import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/event_constants.dart';
import 'package:go_question/core/constants/event_texts.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/core/widgets/buttons/gq_close_button.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/presentation/utils/event_presentation_utils.dart';

class CreateEventDialog extends StatefulWidget {
  final ValueChanged<EventEntity>? onCreate;
  final String? organizerAccountId;

  const CreateEventDialog({super.key, this.onCreate, this.organizerAccountId});

  @override
  State<CreateEventDialog> createState() => _CreateEventDialogState();
}

class _CreateEventDialogState extends State<CreateEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _maxUsersController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _startTime = DateTime.now();
  String _status = EventConstants.statusOpen;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _maxUsersController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickStartTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startTime),
    );
    if (time == null || !mounted) return;

    setState(() {
      _startTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  EventEntity _buildEvent() {
    final now = DateTime.now();
    return EventEntity(
      id: EventPresentationUtils.createEventId(now),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      imageUrl: EventConstants.defaultImageUrl,
      startTime: _startTime,
      location: _locationController.text.trim(),
      category: _categoryController.text.trim(),
      price: double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0,
      maxUsers: int.tryParse(_maxUsersController.text) ?? 0,
      participants: EventConstants.defaultParticipants,
      organizer: EventPresentationUtils.resolveOrganizerId(
        widget.organizerAccountId,
      ),
      status: _status,
      createdAt: now,
      updatedAt: now,
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final event = _buildEvent();
    widget.onCreate?.call(event);
    Navigator.of(context).pop(event);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(UiConstants.boxUnit * 2),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 760),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UiConstants.borderRadius * 6),
            border: Border.all(
              color: const Color(EventConstants.createDialogBorderColorValue),
              width: UiConstants.boxUnit,
            ),
            boxShadow: const [
              BoxShadow(color: Color(0x88000000), offset: Offset(0, 6)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(UiConstants.borderRadius * 4.5),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    EventConstants.createDialogBackgroundAssetPath,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: ColoredBox(
                color: const Color(0x99104A86),
                child: Padding(
                  padding: const EdgeInsets.all(UiConstants.boxUnit * 2),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Center(
                              child: _StrokeTitle(
                                text: EventTexts.createHeaderTitle,
                              ),
                            ),
                          ),
                          GqCloseButton(
                            onTap: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: UiConstants.boxUnit * 1.5),
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            children: [
                              _FormInput(
                                label: EventTexts.createFieldTitle,
                                hint: EventTexts.createHintTitle,
                                controller: _titleController,
                                validator: (v) {
                                  if ((v ?? '').trim().isEmpty) {
                                    return EventTexts.createValidationTitle;
                                  }
                                  return null;
                                },
                              ),
                              _FormDateTimeInput(
                                label: EventTexts.createFieldStart,
                                value:
                                    EventPresentationUtils.formatLongDateTime(
                                      _startTime,
                                    ),
                                onTap: _pickStartTime,
                              ),
                              _FormInput(
                                label: EventTexts.createFieldLocation,
                                hint: EventTexts.createHintLocation,
                                controller: _locationController,
                              ),
                              _FormInput(
                                label: EventTexts.createFieldCategory,
                                hint: EventTexts.createHintCategory,
                                controller: _categoryController,
                              ),
                              _FormInput(
                                label: EventTexts.createFieldPrice,
                                hint: EventTexts.createHintPrice,
                                controller: _priceController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                              ),
                              _FormInput(
                                label: EventTexts.createFieldMaxUsers,
                                hint: EventTexts.createHintMaxUsers,
                                controller: _maxUsersController,
                                keyboardType: TextInputType.number,
                              ),
                              _FormStatusInput(
                                label: EventTexts.createFieldStatus,
                                value: _status,
                                onChanged: (value) =>
                                    setState(() => _status = value),
                              ),
                              _FormInput(
                                label: EventTexts.createFieldDescription,
                                hint: EventTexts.createHintDescription,
                                controller: _descriptionController,
                                maxLines: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: UiConstants.boxUnit),
                      SizedBox(
                        width: double.infinity,
                        child: GQButton(
                          onPressed: _submit,
                          text: EventTexts.buttonAdd,
                          baseColor: const Color(0xFFFFC00F),
                          mainGradient: const LinearGradient(
                            colors: [Color(0xFFFFD54F), Color(0xFFFFC107)],
                          ),
                          outerGradient: const LinearGradient(
                            colors: [Color(0xFFF9A825), Color(0xFFF57F17)],
                          ),
                          height: UiConstants.boxUnit * 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
