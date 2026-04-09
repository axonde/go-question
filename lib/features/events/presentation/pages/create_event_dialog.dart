import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/city_constants.dart';
import 'package:go_question/core/constants/event_constants.dart';
import 'package:go_question/core/constants/event_texts.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/core/widgets/buttons/gq_close_button.dart';
import 'package:go_question/core/widgets/dialogs/gq_dialog_panel.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/presentation/bloc/events_bloc.dart';
import 'package:go_question/features/events/presentation/utils/event_presentation_utils.dart';

part 'create_event_dialog/form_input.dart';
part 'create_event_dialog/form_dropdown_input.dart';
part 'create_event_dialog/form_date_time_input.dart';
part 'create_event_dialog/form_status_input.dart';
part 'create_event_dialog/stroke_title.dart';

class CreateEventDialog extends StatefulWidget {
  final ValueChanged<EventEntity>? onCreate;
  final String? organizerAccountId;
  final EventEntity? initialEvent;

  const CreateEventDialog({
    super.key,
    this.onCreate,
    this.organizerAccountId,
    this.initialEvent,
  });

  @override
  State<CreateEventDialog> createState() => _CreateEventDialogState();
}

class _CreateEventDialogState extends State<CreateEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _maxUsersController = TextEditingController();
  final _descriptionController = TextEditingController();
  late final List<String> _locationOptions;
  late final List<String> _categoryOptions;

  DateTime _startTime = DateTime.now();
  String _status = EventConstants.statusOpen;
  String? _selectedLocation;

  int get _currentParticipantsCount =>
      widget.initialEvent?.participantIds.length ??
      widget.initialEvent?.participants ??
      0;

  @override
  void initState() {
    super.initState();
    final event = widget.initialEvent;
    if (event != null) {
      _titleController.text = event.title;
      _categoryController.text = event.category;
      _priceController.text = event.price.toString();
      _maxUsersController.text = event.maxUsers.toString();
      _descriptionController.text = event.description;
      _startTime = event.startTime;
      _status = event.status;
      _selectedLocation = event.location;
    }
    _locationOptions = _buildOptions(
      CityConstants.cityOptions,
      _selectedLocation,
    );
    _categoryOptions = _buildOptions(
      EventTexts.eventCategoryOptions,
      _categoryController.text,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
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
    final event = widget.initialEvent;
    return EventEntity(
      id: event?.id ?? EventPresentationUtils.createEventId(now),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startTime: _startTime,
      location: _selectedLocation?.trim() ?? '',
      category: _categoryController.text.trim(),
      price: double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0,
      maxUsers: int.tryParse(_maxUsersController.text) ?? 0,
      participants: event?.participants ?? EventConstants.defaultParticipants,
      organizer: EventPresentationUtils.resolveOrganizerId(
        widget.organizerAccountId ?? event?.organizer,
      ),
      status: _status,
      imageUrl: event?.imageUrl,
      participantIds: event?.participantIds ?? const <String>[],
      pendingParticipantIds: event?.pendingParticipantIds ?? const <String>[],
      rejectedParticipantIds: event?.rejectedParticipantIds ?? const <String>[],
      requiresApproval: event?.requiresApproval ?? false,
      visibility: event?.visibility ?? EventConstants.visibilityPublic,
      joinMode: event?.joinMode ?? EventConstants.joinModeOpen,
      createdAt: event?.createdAt ?? now,
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
    return GqDialogPanel(
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Center(
                  child: _StrokeTitle(text: EventTexts.createHeaderTitle),
                ),
              ),
              GqCloseButton(onTap: () => Navigator.of(context).pop()),
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
                    value: EventPresentationUtils.formatLongDateTime(
                      _startTime,
                    ),
                    onTap: _pickStartTime,
                  ),
                  _FormDropdownInput<String>(
                    label: EventTexts.createFieldLocation,
                    hint: EventTexts.createHintLocation,
                    value: _selectedLocation,
                    items: _locationOptions,
                    onChanged: (value) =>
                        setState(() => _selectedLocation = value),
                  ),
                  _FormDropdownInput<String>(
                    label: EventTexts.createFieldCategory,
                    hint: EventTexts.createHintEventType,
                    value: _categoryController.text.isEmpty
                        ? null
                        : _categoryController.text,
                    items: _categoryOptions,
                    onChanged: (value) => setState(() {
                      _categoryController.text = value ?? '';
                    }),
                  ),
                  _FormInput(
                    label: EventTexts.createFieldPrice,
                    hint: EventTexts.createHintPrice,
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  _FormInput(
                    label: EventTexts.createFieldMaxUsers,
                    hint: EventTexts.createHintMaxUsers,
                    controller: _maxUsersController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final maxUsers = int.tryParse((value ?? '').trim()) ?? 0;
                      if (maxUsers <= 0) {
                        return EventTexts.createValidationMaxUsers;
                      }
                      if (maxUsers < _currentParticipantsCount) {
                        return EventTexts.createValidationMaxUsersTooSmall;
                      }
                      return null;
                    },
                  ),
                  _FormStatusInput(
                    label: EventTexts.createFieldStatus,
                    value: _status,
                    onChanged: (value) => setState(() => _status = value),
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
            child: BlocBuilder<EventsBloc, EventsState>(
              builder: (context, state) => GQButton(
                onPressed: _submit,
                isLoading: state.isLoading,
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
          ),
        ],
      ),
    );
  }

  List<String> _buildOptions(List<String> base, String? current) {
    final result = [...base];
    final value = current?.trim();
    if (value != null && value.isNotEmpty && !result.contains(value)) {
      result.add(value);
    }
    return result;
  }
}
