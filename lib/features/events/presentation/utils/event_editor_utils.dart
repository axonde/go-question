import 'package:flutter/material.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/presentation/pages/create_event_dialog.dart';

abstract final class EventEditorUtils {
  EventEditorUtils._();

  static Future<EventEntity?> openEventEditorDialog(
    BuildContext context, {
    required String? organizerAccountId,
    EventEntity? initialEvent,
  }) {
    return showDialog<EventEntity>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CreateEventDialog(
        organizerAccountId: organizerAccountId,
        initialEvent: initialEvent,
      ),
    );
  }
}
