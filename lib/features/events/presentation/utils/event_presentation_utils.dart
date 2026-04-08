import 'package:flutter/material.dart';
import 'package:go_question/core/constants/event_constants.dart';

enum EventViewerRole { organizer, participant }

class EventPresentationUtils {
  static EventViewerRole viewerRoleByEventId(String eventId) {
    return EventConstants.organizerEventIds.contains(eventId)
        ? EventViewerRole.organizer
        : EventViewerRole.participant;
  }

  static String formatLongDateTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final month = EventConstants.monthsLong[value.month];
    return '${value.day} $month ${value.year}, $hour:$minute';
  }

  static String formatShortDateTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final month = EventConstants.monthsShort[value.month];
    return '${value.day} $month, $hour:$minute';
  }

  static String statusLabel(String status) {
    switch (status) {
      case EventConstants.statusOpen:
        return 'Открыт';
      case EventConstants.statusUpcoming:
        return 'Скоро';
      case EventConstants.statusClosed:
        return 'Закрыт';
      default:
        return status;
    }
  }

  static Color statusColor(String status) {
    switch (status) {
      case EventConstants.statusOpen:
        return const Color(0xFF1565C0);
      case EventConstants.statusUpcoming:
        return const Color(0xFFF57F17);
      case EventConstants.statusClosed:
        return const Color(0xFFB71C1C);
      default:
        return const Color(0xFF62697B);
    }
  }
}
