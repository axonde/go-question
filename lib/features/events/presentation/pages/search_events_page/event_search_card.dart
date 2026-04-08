part of '../search_events_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EventSearchCard — карточка ивента. Разворачивается in-place при нажатии.
// ─────────────────────────────────────────────────────────────────────────────

class EventSearchCard extends StatelessWidget {
  final EventEntity event;
  final bool isExpanded;
  final VoidCallback onToggle;

  const EventSearchCard({
    super.key,
    required this.event,
    required this.isExpanded,
    required this.onToggle,
  });

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
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
        alignment: Alignment.topCenter,
        child: DecoratedBox(
          decoration: _cardDecoration,
          child: Padding(
            padding: EdgeInsets.all(UiConstants.boxUnit * 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _StrokeTitle(
                  text: event.title,
                  fontSize: UiConstants.textSize * 1.05,
                  maxLines: 2,
                ),
                SizedBox(height: UiConstants.boxUnit),
                Text(
                  event.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'RussoOne',
                    fontFamilyFallback: ['Roboto', 'sans-serif'],
                    fontSize: UiConstants.textSize * 0.68,
                    color: Color(0xFF7187A8),
                    height: 1.35,
                  ),
                ),
                // Плавное появление/скрытие расширенного контента.
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 260),
                  sizeCurve: Curves.easeInOutCubic,
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: _ExpandedContent(event: event),
                ),
                SizedBox(height: UiConstants.boxUnit * 1.25),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: _MetaRow(event: event)),
                    SizedBox(width: UiConstants.boxUnit * 1.5),
                    _CardJoinButton(event: event),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ExpandedContent — детали + организатор, видны только в развёрнутом виде.
// ─────────────────────────────────────────────────────────────────────────────

class _ExpandedContent extends StatelessWidget {
  final EventEntity event;
  const _ExpandedContent({required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: UiConstants.boxUnit * 1.5),
        const _CardDivider(),
        SizedBox(height: UiConstants.boxUnit * 1.25),
        _ExpandedDetails(event: event),
        SizedBox(height: UiConstants.boxUnit * 1.25),
        const _CardDivider(),
        SizedBox(height: UiConstants.boxUnit * 1.25),
        _OrganizerRow(event: event),
      ],
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) => const Divider(
        height: 1,
        thickness: 0.5,
        color: Color(0xFF62697B),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// _ExpandedDetails — детальные поля ивента.
// ─────────────────────────────────────────────────────────────────────────────

class _ExpandedDetails extends StatelessWidget {
  final EventEntity event;
  const _ExpandedDetails({required this.event});

  String get _dateLabel {
    final t = event.startTime;
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    const months = [
      '',
      'января', 'февраля', 'марта', 'апреля',
      'мая', 'июня', 'июля', 'августа',
      'сентября', 'октября', 'ноября', 'декабря',
    ];
    return '${t.day} ${months[t.month]} ${t.year}, $h:$m';
  }

  String get _priceLabel =>
      event.price == 0 ? 'Бесплатно' : '${event.price.toInt()} ₽';

  Color get _priceColor =>
      event.price == 0 ? const Color(0xFF2E7D32) : const Color(0xFF5D4037);

  String get _statusLabel {
    switch (event.status) {
      case 'open':     return 'Открыт';
      case 'upcoming': return 'Скоро';
      case 'closed':   return 'Закрыт';
      default:         return event.status;
    }
  }

  Color get _statusColor {
    switch (event.status) {
      case 'open':     return const Color(0xFF1565C0);
      case 'upcoming': return const Color(0xFFF57F17);
      case 'closed':   return const Color(0xFFB71C1C);
      default:         return const Color(0xFF62697B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DetailRow(icon: Icons.access_time_outlined, label: _dateLabel),
        SizedBox(height: UiConstants.boxUnit * 0.75),
        _DetailRow(icon: Icons.location_on_outlined, label: event.location),
        SizedBox(height: UiConstants.boxUnit * 0.75),
        _DetailRow(icon: Icons.category_outlined, label: event.category),
        SizedBox(height: UiConstants.boxUnit * 0.75),
        _DetailRow(
          icon: Icons.people_outline,
          label: '${event.participants} / ${event.maxUsers} участников',
        ),
        SizedBox(height: UiConstants.boxUnit * 0.75),
        _DetailRow(
          icon: Icons.payments_outlined,
          label: _priceLabel,
          color: _priceColor,
        ),
        SizedBox(height: UiConstants.boxUnit * 0.75),
        _DetailRow(
          icon: Icons.info_outline,
          label: _statusLabel,
          color: _statusColor,
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _DetailRow({
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
        SizedBox(width: UiConstants.boxUnit),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Clash',
              fontFamilyFallback: const ['Roboto', 'sans-serif'],
              fontSize: UiConstants.textSize * 0.8,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _OrganizerRow — аватар, имя организатора, кнопка «Профиль».
// ─────────────────────────────────────────────────────────────────────────────

class _OrganizerRow extends StatelessWidget {
  final EventEntity event;
  const _OrganizerRow({required this.event});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: UiConstants.boxUnit * 5,
          height: UiConstants.boxUnit * 5,
          decoration: BoxDecoration(
            color: const Color(0xFFA5AEBB),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black,
              width: UiConstants.borderWidth / 2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x44000000),
                blurRadius: 0,
                offset: Offset(0, UiConstants.shadowOffsetY),
              ),
            ],
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: UiConstants.boxUnit * 3,
          ),
        ),
        SizedBox(width: UiConstants.boxUnit),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                event.organizer,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Clash',
                  fontFamilyFallback: ['Roboto', 'sans-serif'],
                  fontSize: UiConstants.textSize * 0.875,
                  color: Color(0xFF3A4560),
                ),
              ),
              Text(
                'Организатор',
                style: TextStyle(
                  fontFamily: 'RussoOne',
                  fontFamilyFallback: const ['Roboto', 'sans-serif'],
                  fontSize: UiConstants.textSize * 0.62,
                  color: const Color(0xFF7187A8),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: UiConstants.boxUnit),
        GQButton(
          onPressed: () {
            // TODO: перейти в профиль организатора.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Профиль организатора')),
            );
          },
          text: 'Профиль',
          baseColor: const Color(0xFF1565C0),
          mainGradient: const LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
          ),
          outerGradient: const LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF0D47A1)],
          ),
          width: UiConstants.boxUnit * 11,
          height: UiConstants.boxUnit * 5,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CardJoinButton — зелёная кнопка «Записаться» через GQButton.
// ─────────────────────────────────────────────────────────────────────────────

class _CardJoinButton extends StatelessWidget {
  final EventEntity event;
  const _CardJoinButton({required this.event});

  @override
  Widget build(BuildContext context) {
    return GQButton(
      onPressed: () {
        // TODO: запрос на участие через Cubit/Bloc.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Запрос на участие отправлен')),
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
      width: UiConstants.boxUnit * 11,
      height: UiConstants.boxUnit * 5,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _MetaRow — мета-данные в 2 строки.
// ─────────────────────────────────────────────────────────────────────────────

class _MetaRow extends StatelessWidget {
  final EventEntity event;
  const _MetaRow({required this.event});

  String get _timeLabel {
    final t = event.startTime;
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    const months = [
      '', 'янв', 'фев', 'мар', 'апр',
      'май', 'июн', 'июл', 'авг',
      'сен', 'окт', 'ноя', 'дек',
    ];
    return '${t.day} ${months[t.month]}, $h:$m';
  }

  String get _priceLabel =>
      event.price == 0 ? 'Бесплатно' : '${event.price.toInt()} ₽';

  Color get _priceColor =>
      event.price == 0 ? const Color(0xFF2E7D32) : const Color(0xFF5D4037);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: _MetaChip(
                icon: Icons.access_time_outlined,
                label: _timeLabel,
              ),
            ),
            SizedBox(width: UiConstants.boxUnit),
            Flexible(
              child: _MetaChip(
                icon: Icons.people_outline,
                label: '${event.participants}/${event.maxUsers}',
              ),
            ),
          ],
        ),
        SizedBox(height: UiConstants.boxUnit * 0.4),
        _MetaChip(
          icon: Icons.payments_outlined,
          label: _priceLabel,
          color: _priceColor,
        ),
      ],
    );
  }
}

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
