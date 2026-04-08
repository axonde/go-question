import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/event_constants.dart';
import 'package:go_question/core/constants/event_texts.dart';
import 'package:go_question/core/constants/home_ui_constants.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/core/widgets/buttons/gq_close_button.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/presentation/utils/event_presentation_utils.dart';

part 'home_events/events_list.dart';
part 'home_events/event_card/card_decoration.dart';
part 'home_events/event_card/event_card.dart';
part 'home_events/event_card/event_details_dialog.dart';
part 'home_events/event_card/detail_line.dart';
part 'home_events/event_card/action_button.dart';
part 'home_events/event_card/empty_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Временные захардкоженные события.
// TODO: заменить на загрузку из Firestore.
// ─────────────────────────────────────────────────────────────────────────────

final _kMockEvents = [
  _EventCardData(
    event: EventEntity(
      id: 'home-1',
      title: EventTexts.mockEvent1Title,
      description: EventTexts.mockEvent1Description,
      startTime: DateTime(2026, 4, 12, 10),
      location: EventTexts.mockEvent1Location,
      category: EventTexts.mockEvent1Category,
      price: 0,
      maxUsers: 64,
      participants: 32,
      organizer: EventTexts.mockEvent1Organizer,
      status: EventConstants.statusOpen,
      createdAt: DateTime(2026, 3),
      updatedAt: DateTime(2026, 3),
    ),
    viewerRole: EventViewerRole.participant,
  ),
  _EventCardData(
    event: EventEntity(
      id: 'home-2',
      title: EventTexts.mockEvent2Title,
      description: EventTexts.mockEvent2Description,
      startTime: DateTime(2026, 4, 15, 12),
      location: EventTexts.mockEvent2Location,
      category: EventTexts.mockEvent2Category,
      price: 500,
      maxUsers: 16,
      participants: 14,
      organizer: EventTexts.mockEvent2Organizer,
      status: EventConstants.statusOpen,
      createdAt: DateTime(2026, 3, 5),
      updatedAt: DateTime(2026, 3, 5),
    ),
    viewerRole: EventViewerRole.organizer,
  ),
  _EventCardData(
    event: EventEntity(
      id: 'home-3',
      title: EventTexts.mockEvent3Title,
      description: EventTexts.mockEvent3Description,
      startTime: DateTime(2026, 4, 20, 9, 30),
      location: EventTexts.mockEvent3Location,
      category: EventTexts.mockEvent3Category,
      price: 300,
      maxUsers: 128,
      participants: 64,
      organizer: EventTexts.mockEvent3Organizer,
      status: EventConstants.statusOpen,
      createdAt: DateTime(2026, 3, 10),
      updatedAt: DateTime(2026, 3, 10),
    ),
    viewerRole: EventViewerRole.participant,
  ),
  _EventCardData(
    event: EventEntity(
      id: 'home-4',
      title: EventTexts.mockEvent4Title,
      description: EventTexts.mockEvent4Description,
      startTime: DateTime(2026, 5, 5, 11),
      location: EventTexts.mockEvent4Location,
      category: EventTexts.mockEvent4Category,
      price: 200,
      maxUsers: 32,
      participants: 18,
      organizer: EventTexts.mockEvent4Organizer,
      status: EventConstants.statusOpen,
      createdAt: DateTime(2026, 3, 15),
      updatedAt: DateTime(2026, 3, 15),
    ),
    viewerRole: EventViewerRole.participant,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// _EventData — plain-модель события для отображения.
// ─────────────────────────────────────────────────────────────────────────────

class _EventCardData {
  final EventEntity event;
  final EventViewerRole viewerRole;

  const _EventCardData({required this.event, required this.viewerRole});
}

// ─────────────────────────────────────────────────────────────────────────────
// HomeEvents — зона событий на главном экране.
//
// ≤ 3 события → три фиксированных рамки без скролла (пустые — заглушки).
//  4+ событий → те же рамки той же высоты, но в скролящемся списке.
// ─────────────────────────────────────────────────────────────────────────────

class HomeEvents extends StatelessWidget {
  const HomeEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final sorted = [..._kMockEvents]
      ..sort((a, b) => a.event.startTime.compareTo(b.event.startTime));
    return _EventsList(events: sorted);
  }
}
