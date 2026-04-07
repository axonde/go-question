part of '../home_events.dart';

// ─────────────────────────────────────────────────────────────────────────────
// _EventsList — единственная ответственность: горизонтальная раскладка и скролл.
//
// ≤ 3 события → Row из трёх равных слотов (Expanded), без скролла.
//               Пустые места → _EmptyCard.
//  4+ событий → SingleChildScrollView по горизонтали.
//               Карточки той же ширины, частично виден 4-й — намёк на скролл.
// ─────────────────────────────────────────────────────────────────────────────

class _EventsList extends StatelessWidget {
  final List<_EventData> events;

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

        final scrollable = events.length > _visibleCount;

        return Padding(
          padding: const EdgeInsets.only(top: vPad, bottom: bPad * 2),
          child: scrollable
              ? _scrollableRow(cardW, cardH, gap, hPad)
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: hPad),
                  child: _fixedRow(cardW, cardH, gap),
                ),
        );
      },
    );
  }

  Widget _fixedRow(double cardW, double cardH, double gap) {
    return Row(
      children: [
        for (int i = 0; i < _visibleCount; i++) ...[
          if (i > 0) SizedBox(width: gap),
          SizedBox(
            width: cardW,
            height: cardH,
            child: i < events.length
                ? _EventCard(event: events[i])
                : const _EmptyCard(),
          ),
        ],
      ],
    );
  }

  Widget _scrollableRow(double cardW, double cardH, double gap, double hPad) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          SizedBox(width: hPad),
          for (int i = 0; i < events.length; i++) ...[
            if (i > 0) SizedBox(width: gap),
            SizedBox(
              width: cardW,
              height: cardH,
              child: _EventCard(event: events[i]),
            ),
          ],
          SizedBox(width: hPad),
        ],
      ),
    );
  }
}
