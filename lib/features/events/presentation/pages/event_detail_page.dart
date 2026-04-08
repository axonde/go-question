import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EventDetailSheet — всплывающее окно с деталями ивента.
// Открывается через showModalBottomSheet + DraggableScrollableSheet.
// ─────────────────────────────────────────────────────────────────────────────

class EventDetailSheet extends StatelessWidget {
  final EventEntity event;

  const EventDetailSheet({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UiConstants.borderRadius * 8),
        ),
        border: Border(
          top: BorderSide(color: Color(0xFF62697B)),
          left: BorderSide(color: Color(0xFF62697B)),
          right: BorderSide(color: Color(0xFF62697B)),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xCC000000),
            offset: Offset(0, -UiConstants.shadowOffsetY),
          ),
        ],
      ),
      child: Column(
        children: [
          _DetailSheetHeader(event: event),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                UiConstants.boxUnit * 2,
                UiConstants.boxUnit * 2,
                UiConstants.boxUnit * 2,
                UiConstants.boxUnit * 2,
              ),
              children: [
                const _SectionLabel(text: 'Описание'),
                const SizedBox(height: UiConstants.boxUnit),
                Text(
                  event.description,
                  style: const TextStyle(
                    fontFamily: 'RussoOne',
                    fontFamilyFallback: ['Roboto', 'sans-serif'],
                    fontSize: UiConstants.textSize * 0.75,
                    color: Color(0xFF3A4560),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: UiConstants.boxUnit * 2),
                const _SectionLabel(text: 'Детали'),
                const SizedBox(height: UiConstants.boxUnit),
                _InfoCard(event: event),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              UiConstants.boxUnit * 2,
              0,
              UiConstants.boxUnit * 2,
              UiConstants.boxUnit * 2,
            ),
            child: LayoutBuilder(
              builder: (_, c) => GQButton(
                onPressed: () {
                  // TODO: отправить запрос на участие через Cubit/Bloc.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Запрос на участие отправлен'),
                    ),
                  );
                },
                text: 'Записаться',
                baseColor: const Color(0xFF2E7D32),
                mainGradient: const LinearGradient(
                  colors: [Color(0xFF43A047), Color(0xFF388E3C)],
                ),
                outerGradient: const LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF1B5E20)],
                ),
                width: c.maxWidth,
                height: UiConstants.boxUnit * 7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DetailSheetHeader — заголовок с кнопкой закрытия.
// ─────────────────────────────────────────────────────────────────────────────

class _DetailSheetHeader extends StatelessWidget {
  final EventEntity event;

  const _DetailSheetHeader({required this.event});

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
        boxShadow: [BoxShadow(color: Color(0xCC000000), offset: Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UiConstants.horizontalPadding * 2,
          vertical: UiConstants.verticalPadding * 1.5,
        ),
        child: Row(
          children: [
            Expanded(child: _StrokeTitle(text: event.title, maxLines: 2)),
            const SizedBox(width: UiConstants.boxUnit),
            GQButton(
              onPressed: () => Navigator.of(context).pop(),
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
// _InfoCard — карточка со всеми полями ивента.
// ─────────────────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final EventEntity event;

  const _InfoCard({required this.event});

  String get _dateLabel {
    final t = event.startTime;
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    const months = [
      '',
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря',
    ];
    return '${t.day} ${months[t.month]} ${t.year}, $h:$m';
  }

  String get _priceLabel =>
      event.price == 0 ? 'Бесплатно' : '${event.price.toInt()} ₽';

  Color get _priceColor =>
      event.price == 0 ? const Color(0xFF2E7D32) : const Color(0xFF5D4037);

  String get _statusLabel {
    switch (event.status) {
      case 'open':
        return 'Открыт';
      case 'upcoming':
        return 'Скоро';
      case 'closed':
        return 'Закрыт';
      default:
        return event.status;
    }
  }

  Color get _statusColor {
    switch (event.status) {
      case 'open':
        return const Color(0xFF1565C0);
      case 'upcoming':
        return const Color(0xFFF57F17);
      case 'closed':
        return const Color(0xFFB71C1C);
      default:
        return const Color(0xFF62697B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFFDEE7F6),
        border: Border.fromBorderSide(BorderSide(color: Color(0xFF62697B))),
        borderRadius: BorderRadius.all(
          Radius.circular(UiConstants.borderRadius * 5),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x55000000),
            offset: Offset(0, UiConstants.shadowOffsetY),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(UiConstants.boxUnit * 2),
        child: Column(
          children: [
            _InfoRow(icon: Icons.access_time_outlined, label: _dateLabel),
            _InfoDivider(),
            _InfoRow(icon: Icons.location_on_outlined, label: event.location),
            _InfoDivider(),
            _InfoRow(icon: Icons.category_outlined, label: event.category),
            _InfoDivider(),
            _InfoRow(icon: Icons.person_outline, label: event.organizer),
            _InfoDivider(),
            _InfoRow(
              icon: Icons.people_outline,
              label: '${event.participants} / ${event.maxUsers} участников',
            ),
            _InfoDivider(),
            _InfoRow(
              icon: Icons.payments_outlined,
              label: _priceLabel,
              color: _priceColor,
            ),
            _InfoDivider(),
            _InfoRow(
              icon: Icons.info_outline,
              label: _statusLabel,
              color: _statusColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: UiConstants.boxUnit * 0.75),
      child: Divider(height: 1, thickness: 0.5, color: Color(0xFF62697B)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    this.color = const Color(0xFF3A4560),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: UiConstants.textSize, color: color),
        const SizedBox(width: UiConstants.boxUnit),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Clash',
              fontFamilyFallback: const ['Roboto', 'sans-serif'],
              fontSize: UiConstants.textSize * 0.875,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SectionLabel — подпись раздела со stroke+тенью.
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) =>
      _StrokeTitle(text: text, fontSize: UiConstants.textSize * 1.25);
}

// ─────────────────────────────────────────────────────────────────────────────
// _StrokeTitle — заголовок с чёрной обводкой и тенью.
// ─────────────────────────────────────────────────────────────────────────────

class _StrokeTitle extends StatelessWidget {
  final String text;
  final double fontSize;
  final int maxLines;

  const _StrokeTitle({
    required this.text,
    this.fontSize = UiConstants.textSize * 1.5,
    this.maxLines = 1,
  });

  static const _family = 'Clash';
  static const _fallback = ['Roboto', 'sans-serif'];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          maxLines: maxLines,
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
        Text(
          text,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: _family,
            fontFamilyFallback: _fallback,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: const [
              Shadow(offset: Offset(0, UiConstants.textShadowOffsetY)),
            ],
          ),
        ),
      ],
    );
  }
}
