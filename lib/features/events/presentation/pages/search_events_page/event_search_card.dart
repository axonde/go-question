part of '../search_events_page.dart';

// Фиксированная высота всех карточек.
const double _kCardHeight = UiConstants.boxUnit * 18; // 144px

// ─────────────────────────────────────────────────────────────────────────────
// EventSearchCard — карточка ивента в списке поиска.
// ─────────────────────────────────────────────────────────────────────────────

class EventSearchCard extends StatelessWidget {
  final EventEntity event;

  const EventSearchCard({required this.event});

  static const _cardDecoration = BoxDecoration(
    color: Color(0xFFDEE7F6),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFF62697B), width: UiConstants.borderWidth / 2),
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(UiConstants.borderRadius * 5),
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x55000000),
        blurRadius: 0,
        spreadRadius: 0,
        offset: Offset(0, UiConstants.shadowOffsetY),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kCardHeight,
      child: DecoratedBox(
        decoration: _cardDecoration,
        child: Padding(
          padding: EdgeInsets.all(UiConstants.boxUnit * 1.5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _EventPhoto(imageUrl: event.imageUrl),
              SizedBox(width: UiConstants.boxUnit * 1.5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StrokeTitle(
                      text: event.title,
                      fontSize: UiConstants.textSize * 1.05,
                    ),
                    SizedBox(height: UiConstants.boxUnit * 0.5),
                    Expanded(
                      child: Text(
                        event.description,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'RussoOne',
                          fontFamilyFallback: ['Roboto', 'sans-serif'],
                          fontSize: UiConstants.textSize * 0.68,
                          color: Color(0xFF7187A8),
                          height: 1.35,
                        ),
                      ),
                    ),
                    SizedBox(height: UiConstants.boxUnit * 0.5),
                    _MetaRow(event: event),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _EventPhoto — квадрат с фото или иконкой фотоаппарата.
// ─────────────────────────────────────────────────────────────────────────────

class _EventPhoto extends StatelessWidget {
  final String imageUrl;

  const _EventPhoto({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFA5AEBB),
          borderRadius: BorderRadius.all(
            Radius.circular(UiConstants.borderRadius * 4),
          ),
          border: Border.fromBorderSide(
            BorderSide(color: Colors.black, width: UiConstants.borderWidth / 2),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x44000000),
              blurRadius: 0,
              spreadRadius: 0,
              offset: Offset(0, UiConstants.shadowOffsetY),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _PhotoPlaceholder(),
              )
            : const _PhotoPlaceholder(),
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.photo_camera,
        color: Color(0xFF94A9C3),
        size: UiConstants.boxUnit * 4,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _MetaRow — строка метаданных: время, участники, цена.
// ─────────────────────────────────────────────────────────────────────────────

class _MetaRow extends StatelessWidget {
  final EventEntity event;

  const _MetaRow({required this.event});

  String get _timeLabel {
    final t = event.startTime;
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    const months = [
      '',
      'янв',
      'фев',
      'мар',
      'апр',
      'май',
      'июн',
      'июл',
      'авг',
      'сен',
      'окт',
      'ноя',
      'дек',
    ];
    return '${t.day} ${months[t.month]}, $h:$m';
  }

  String get _priceLabel =>
      event.price == 0 ? 'Бесплатно' : '${event.price.toInt()} ₽';

  Color get _priceColor =>
      event.price == 0 ? const Color(0xFF2E7D32) : const Color(0xFF5D4037);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: _MetaChip(icon: Icons.access_time_outlined, label: _timeLabel),
        ),
        SizedBox(width: UiConstants.boxUnit),
        Flexible(
          child: _MetaChip(
            icon: Icons.people_outline,
            label: '${event.participants}/${event.maxUsers}',
          ),
        ),
        SizedBox(width: UiConstants.boxUnit),
        Flexible(
          child: _MetaChip(
            icon: Icons.payments_outlined,
            label: _priceLabel,
            color: _priceColor,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _MetaChip — иконка + текст для одного мета-поля.
// ─────────────────────────────────────────────────────────────────────────────

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaChip({
    required this.icon,
    required this.label,
    this.color = const Color(0xFF62697B),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: UiConstants.textSize * 0.85, color: color),
        SizedBox(width: UiConstants.boxUnit * 0.3),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Clash',
              fontFamilyFallback: const ['Roboto', 'sans-serif'],
              fontSize: UiConstants.textSize * 0.68,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
