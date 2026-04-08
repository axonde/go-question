part of '../search_events_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EventSearchCard — карточка ивента. Разворачивается in-place при нажатии.
// ─────────────────────────────────────────────────────────────────────────────

class EventSearchCard extends StatelessWidget {
  static const _cardDecoration = BoxDecoration(
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
  );
  final EventEntity event;
  final EventViewerRole viewerRole;
  final bool isExpanded;

  final VoidCallback onToggle;

  const EventSearchCard({
    super.key,
    required this.event,
    required this.viewerRole,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        child: DecoratedBox(
          decoration: _cardDecoration,
          child: Padding(
            padding: const EdgeInsets.all(UiConstants.boxUnit * 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _StrokeTitle(
                  text: event.title,
                  fontSize: UiConstants.textSize * 1.05,
                  maxLines: 2,
                ),
                const SizedBox(height: UiConstants.boxUnit),
                Text(
                  event.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: EventTexts.fontRussoOne,
                    fontFamilyFallback: EventTexts.fontFallback,
                    fontSize: UiConstants.textSize * 0.68,
                    color: Color(0xFF7187A8),
                    height: 1.35,
                  ),
                ),
                // Плавное появление/скрытие расширенного контента.
                AnimatedSize(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeInOutCubic,
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  child: isExpanded
                      ? _ExpandedContent(event: event)
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: UiConstants.boxUnit * 1.25),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: _MetaRow(event: event)),
                    const SizedBox(width: UiConstants.boxUnit * 1.5),
                    _CardActions(event: event, viewerRole: viewerRole),
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
// _CardActions — набор кнопок в зависимости от роли пользователя.
// ─────────────────────────────────────────────────────────────────────────────

class _CardActions extends StatelessWidget {
  final EventEntity event;
  final EventViewerRole viewerRole;

  const _CardActions({required this.event, required this.viewerRole});

  @override
  Widget build(BuildContext context) => viewerRole == EventViewerRole.organizer
      ? _OrganizerActions(event: event)
      : _JoinAction(event: event);
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, thickness: 0.5, color: Color(0xFF62697B));
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
        const SizedBox(width: UiConstants.boxUnit),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: EventTexts.fontClash,
              fontFamilyFallback: EventTexts.fontFallback,
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
        const SizedBox(height: UiConstants.boxUnit * 1.5),
        const _CardDivider(),
        const SizedBox(height: UiConstants.boxUnit * 1.25),
        _ExpandedDetails(event: event),
        const SizedBox(height: UiConstants.boxUnit * 1.25),
        const _CardDivider(),
        const SizedBox(height: UiConstants.boxUnit * 1.25),
        _OrganizerRow(event: event),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ExpandedDetails — детальные поля ивента.
// ─────────────────────────────────────────────────────────────────────────────

class _ExpandedDetails extends StatelessWidget {
  final EventEntity event;
  const _ExpandedDetails({required this.event});

  String get _dateLabel =>
      EventPresentationUtils.formatLongDateTime(event.startTime);

  Color get _priceColor =>
      event.price == 0 ? const Color(0xFF2E7D32) : const Color(0xFF5D4037);

  String get _priceLabel => event.price == 0
      ? EventTexts.filterFree
      : '${event.price.toInt()} ${EventTexts.currencyRub}';

  Color get _statusColor => EventPresentationUtils.statusColor(event.status);

  String get _statusLabel => EventPresentationUtils.statusLabel(event.status);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DetailRow(icon: Icons.access_time_outlined, label: _dateLabel),
        const SizedBox(height: UiConstants.boxUnit * 0.75),
        _DetailRow(icon: Icons.location_on_outlined, label: event.location),
        const SizedBox(height: UiConstants.boxUnit * 0.75),
        _DetailRow(icon: Icons.category_outlined, label: event.category),
        const SizedBox(height: UiConstants.boxUnit * 0.75),
        _DetailRow(
          icon: Icons.people_outline,
          label:
              '${event.participants} / ${event.maxUsers} ${EventTexts.participantsWord}',
        ),
        const SizedBox(height: UiConstants.boxUnit * 0.75),
        _DetailRow(
          icon: Icons.payments_outlined,
          label: _priceLabel,
          color: _priceColor,
        ),
        const SizedBox(height: UiConstants.boxUnit * 0.75),
        _DetailRow(
          icon: Icons.info_outline,
          label: _statusLabel,
          color: _statusColor,
        ),
      ],
    );
  }
}

class _JoinAction extends StatelessWidget {
  final EventEntity event;

  const _JoinAction({required this.event});

  @override
  Widget build(BuildContext context) => GQButton(
    onPressed: () {
      // TODO: запрос на участие через Cubit/Bloc.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(EventTexts.snackBarJoinRequestSent)),
      );
    },
    text: EventTexts.buttonJoin,
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
        const SizedBox(width: UiConstants.boxUnit * 0.3),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: EventTexts.fontClash,
              fontFamilyFallback: EventTexts.fontFallback,
              fontSize: UiConstants.textSize * 0.68,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _MetaRow — мета-данные в 2 строки.
// ─────────────────────────────────────────────────────────────────────────────

class _MetaRow extends StatelessWidget {
  final EventEntity event;
  const _MetaRow({required this.event});

  Color get _priceColor =>
      event.price == 0 ? const Color(0xFF2E7D32) : const Color(0xFF5D4037);

  String get _priceLabel => event.price == 0
      ? EventTexts.filterFree
      : '${event.price.toInt()} ${EventTexts.currencyRub}';

  String get _timeLabel =>
      EventPresentationUtils.formatShortDateTime(event.startTime);

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
            const SizedBox(width: UiConstants.boxUnit),
            Flexible(
              child: _MetaChip(
                icon: Icons.people_outline,
                label: '${event.participants}/${event.maxUsers}',
              ),
            ),
          ],
        ),
        const SizedBox(height: UiConstants.boxUnit * 0.4),
        _MetaChip(
          icon: Icons.payments_outlined,
          label: _priceLabel,
          color: _priceColor,
        ),
      ],
    );
  }
}

class _OrganizerActions extends StatelessWidget {
  final EventEntity event;

  const _OrganizerActions({required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GQButton(
          onPressed: () {
            // TODO: открыть редактирование ивента.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(EventTexts.snackBarEditEvent)),
            );
          },
          text: EventTexts.buttonEdit,
          baseColor: const Color(0xFF1565C0),
          mainGradient: const LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
          ),
          outerGradient: const LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF0D47A1)],
          ),
          width: UiConstants.boxUnit * 13,
          height: UiConstants.boxUnit * 4.5,
        ),
        const SizedBox(height: UiConstants.boxUnit * 0.75),
        GQButton(
          onPressed: () {
            // TODO: открыть список участников.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(EventTexts.snackBarParticipantsList),
              ),
            );
          },
          text: EventTexts.buttonParticipants,
          baseColor: const Color(0xFF2E7D32),
          mainGradient: const LinearGradient(
            colors: [Color(0xFF43A047), Color(0xFF388E3C)],
          ),
          outerGradient: const LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF1B5E20)],
          ),
          width: UiConstants.boxUnit * 13,
          height: UiConstants.boxUnit * 4.5,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _OrganizerRow — аватар и имя организатора.
// ─────────────────────────────────────────────────────────────────────────────

class _OrganizerRow extends StatelessWidget {
  final EventEntity event;
  const _OrganizerRow({required this.event});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: UiConstants.boxUnit * 5,
          height: UiConstants.boxUnit * 5,
          decoration: BoxDecoration(
            color: const Color(0xFFA5AEBB),
            shape: BoxShape.circle,
            border: Border.all(),
            boxShadow: const [
              BoxShadow(
                color: Color(0x44000000),
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
        const SizedBox(width: UiConstants.boxUnit),
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
                  fontFamily: EventTexts.fontClash,
                  fontFamilyFallback: EventTexts.fontFallback,
                  fontSize: UiConstants.textSize * 0.875,
                  color: Color(0xFF3A4560),
                ),
              ),
              const Text(
                EventTexts.organizerLabel,
                style: TextStyle(
                  fontFamily: EventTexts.fontRussoOne,
                  fontFamilyFallback: EventTexts.fontFallback,
                  fontSize: UiConstants.textSize * 0.62,
                  color: Color(0xFF7187A8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
