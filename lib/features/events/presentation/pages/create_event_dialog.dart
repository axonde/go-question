import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/event_constants.dart';
import 'package:go_question/core/constants/event_texts.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/core/widgets/buttons/gq_close_button.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/presentation/utils/event_presentation_utils.dart';

part 'create_event_dialog/form_input.dart';
part 'create_event_dialog/form_date_time_input.dart';
part 'create_event_dialog/form_status_input.dart';
part 'create_event_dialog/stroke_title.dart';

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
