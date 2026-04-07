import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';

part 'home_events/event_card.dart';
part 'home_events/events_list.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Временные захардкоженные события.
// TODO: заменить на загрузку из Firestore.
// ─────────────────────────────────────────────────────────────────────────────

const _kMockEvents = [
  _EventData(
    title: 'Турнир по Го — Весна 2026',
    isOrganizer: false,
    date: '12 апр',
  ),
  _EventData(title: 'Клубный чемпионат', isOrganizer: true, date: '15 апр'),
  _EventData(title: 'Открытый турнир СПб', isOrganizer: false, date: '20 апр'),
  _EventData(title: 'Городской кубок', isOrganizer: false, date: '5 мая'),
];

// ─────────────────────────────────────────────────────────────────────────────
// _EventData — plain-модель события для отображения.
// ─────────────────────────────────────────────────────────────────────────────

class _EventData {
  final String title;
  final bool isOrganizer;
  final String date;

  const _EventData({
    required this.title,
    required this.isOrganizer,
    required this.date,
  });
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
    return const _EventsList(events: _kMockEvents);
  }
}
