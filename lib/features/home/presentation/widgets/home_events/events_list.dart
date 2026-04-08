part of '../home_events.dart';

// ─────────────────────────────────────────────────────────────────────────────
// _EventsList — единственная ответственность: горизонтальная раскладка и скролл.
//
// Каждый блок содержит ровно 3 слота.
// Если событий меньше 3, оставшиеся слоты заполняются _EmptyCard.
// Если событий больше 3, показываем горизонтальные страницы-блоки по 3 слота.
// ─────────────────────────────────────────────────────────────────────────────

class _EventsList extends StatelessWidget {
  final List<_EventCardData> events;

  const _EventsList({required this.events});

  static const int _visibleCount = 3;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final totalW = constraints.maxWidth;
        final totalH = constraints.maxHeight;
        const hPad = UiConstants.horizontalPadding * 2;
        const vPad = UiConstants.verticalPadding;
        const gap = UiConstants.boxUnit;

        const bPad = UiConstants.bottomPadding;
        final cardH = totalH - vPad - bPad * 2;
        final cardW =
            (totalW - hPad * 2 - gap * (_visibleCount - 1)) / _visibleCount;

        return Padding(
          padding: const EdgeInsets.only(top: vPad, bottom: bPad * 2),
          child: events.length > _visibleCount
              ? _pagedRow(totalW, cardW, cardH, gap, hPad)
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: hPad),
                  child: _buildPage(events, cardW, cardH, gap),
                ),
        );
      },
    );
  }

  Widget _buildPage(
    List<_EventCardData> pageEvents,
    double cardW,
    double cardH,
    double gap,
  ) {
    return Row(
      children: [
        for (int i = 0; i < _visibleCount; i++) ...[
          if (i > 0) SizedBox(width: gap),
          SizedBox(
            width: cardW,
            height: cardH,
            child: i < pageEvents.length
                ? _EventCard(eventCardData: pageEvents[i])
                : const _EmptyCard(),
          ),
        ],
      ],
    );
  }

  Widget _pagedRow(
    double totalW,
    double cardW,
    double cardH,
    double gap,
    double hPad,
  ) {
    final pageCount = (events.length / _visibleCount).ceil();

    return ClipRect(
      child: PageView.builder(
        padEnds: false,
        itemCount: pageCount,
        itemBuilder: (_, pageIndex) {
          final start = pageIndex * _visibleCount;
          final end = (start + _visibleCount).clamp(0, events.length);
          final pageEvents = events.sublist(start, end);

          return SizedBox(
            width: totalW,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: _buildPage(pageEvents, cardW, cardH, gap),
            ),
          );
        },
        physics: const PageScrollPhysics(),
      ),
    );
  }
}
