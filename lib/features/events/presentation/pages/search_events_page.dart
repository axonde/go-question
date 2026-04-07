import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/features/events/domain/event_entity.dart';

part 'search_events_page/event_search_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Мок-данные. TODO: заменить на загрузку из Firestore через Cubit/Bloc.
// ─────────────────────────────────────────────────────────────────────────────

final _kMockEvents = [
  EventEntity(
    id: '1',
    title: 'Весенний кубок по Го',
    description:
        'Открытый городской турнир для всех уровней подготовки. Приглашаем игроков от 15 кю до 3 дана включительно. Призовой фонд — сертификаты и памятные призы.',
    imageUrl: '',
    startTime: DateTime(2026, 4, 12, 10, 0),
    location: 'Санкт-Петербург',
    category: 'Турнир',
    price: 0,
    maxUsers: 64,
    participants: 32,
    organizer: 'Клуб СПбГУ',
    status: 'open',
    createdAt: DateTime(2026, 3, 1),
    updatedAt: DateTime(2026, 3, 1),
  ),
  EventEntity(
    id: '2',
    title: 'Клубный чемпионат',
    description:
        'Внутренний чемпионат клуба «Камень» по системе Mac-Mahon. Участие только для членов клуба.',
    imageUrl: '',
    startTime: DateTime(2026, 4, 15, 12, 0),
    location: 'Москва',
    category: 'Чемпионат',
    price: 500,
    maxUsers: 16,
    participants: 14,
    organizer: 'Клуб «Камень»',
    status: 'open',
    createdAt: DateTime(2026, 3, 5),
    updatedAt: DateTime(2026, 3, 5),
  ),
  EventEntity(
    id: '3',
    title: 'Открытый турнир СПб',
    description:
        'Ежегодный открытый турнир Санкт-Петербурга. Участники со всей России и ближнего зарубежья. Формат — 7 туров Swiss.',
    imageUrl: '',
    startTime: DateTime(2026, 4, 20, 9, 30),
    location: 'Санкт-Петербург',
    category: 'Турнир',
    price: 300,
    maxUsers: 128,
    participants: 64,
    organizer: 'Федерация Го России',
    status: 'open',
    createdAt: DateTime(2026, 3, 10),
    updatedAt: DateTime(2026, 3, 10),
  ),
  EventEntity(
    id: '4',
    title: 'Городской кубок',
    description:
        'Кубок города среди любителей. Принимают участие игроки без разряда.',
    imageUrl: '',
    startTime: DateTime(2026, 5, 5, 11, 0),
    location: 'Новосибирск',
    category: 'Кубок',
    price: 200,
    maxUsers: 32,
    participants: 18,
    organizer: 'Городской клуб',
    status: 'open',
    createdAt: DateTime(2026, 3, 15),
    updatedAt: DateTime(2026, 3, 15),
  ),
  EventEntity(
    id: '5',
    title: 'Летний фестиваль Го',
    description:
        'Неформальный фестиваль с мастер-классами, лекциями и товарищескими партиями. Подходит для начинающих.',
    imageUrl: '',
    startTime: DateTime(2026, 6, 1, 10, 0),
    location: 'Екатеринбург',
    category: 'Фестиваль',
    price: 0,
    maxUsers: 200,
    participants: 87,
    organizer: 'Уральский клуб Го',
    status: 'upcoming',
    createdAt: DateTime(2026, 3, 20),
    updatedAt: DateTime(2026, 3, 20),
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// SearchEventsSheet — bottom sheet поиска ивентов.
// Открывается через showModalBottomSheet из HomePage.
// ─────────────────────────────────────────────────────────────────────────────

class SearchEventsSheet extends StatelessWidget {
  const SearchEventsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UiConstants.borderRadius * 8),
        ),
        border: Border(
          top: BorderSide(
            color: Color(0xFF62697B),
            width: UiConstants.borderWidth / 2,
          ),
          left: BorderSide(
            color: Color(0xFF62697B),
            width: UiConstants.borderWidth / 2,
          ),
          right: BorderSide(
            color: Color(0xFF62697B),
            width: UiConstants.borderWidth / 2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xCC000000),
            blurRadius: 0,
            offset: Offset(0, -UiConstants.shadowOffsetY),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _SheetHeader(onClose: () => Navigator.of(context).pop()),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(
                UiConstants.boxUnit * 2,
                UiConstants.boxUnit,
                UiConstants.boxUnit * 2,
                UiConstants.boxUnit * 3,
              ),
              itemCount: _kMockEvents.length,
              separatorBuilder: (_, __) =>
                  SizedBox(height: UiConstants.boxUnit * 1.5),
              itemBuilder: (_, i) => EventSearchCard(event: _kMockEvents[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SheetHeader — заголовок bottom sheet с кнопкой закрытия.
// ─────────────────────────────────────────────────────────────────────────────

class _SheetHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _SheetHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UiConstants.borderRadius * 8),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xCC000000),
            blurRadius: 0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: UiConstants.horizontalPadding * 2,
          vertical: UiConstants.verticalPadding * 1.5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _StrokeTitle(text: 'Поиск ивента')),
            SizedBox(width: UiConstants.boxUnit),
            GQButton(
              onPressed: onClose,
              icon: Icons.close_rounded,
              baseColor: const Color(0xFFE53935),
              width: UiConstants.boxUnit * 5.5,
              height: UiConstants.boxUnit * 5.5,
              aspectRatio: 1,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StrokeTitle — заголовок с чёрной обводкой и тенью вниз (как GoButton).
// ─────────────────────────────────────────────────────────────────────────────

class _StrokeTitle extends StatelessWidget {
  final String text;
  final double fontSize;

  const _StrokeTitle({
    required this.text,
    this.fontSize = UiConstants.textSize * 1.5,
  });

  static const _family = 'Clash';
  static const _fallback = ['Roboto', 'sans-serif'];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Обводка
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: _family,
            fontFamilyFallback: _fallback,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = UiConstants.strokeWidth
              ..color = Colors.black,
          ),
        ),
        // Заливка + тень
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: _family,
            fontFamilyFallback: _fallback,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black,
                offset: Offset(0, UiConstants.shadowOffsetY),
                blurRadius: 0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
