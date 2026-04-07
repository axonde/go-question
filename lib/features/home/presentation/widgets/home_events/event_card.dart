part of '../home_events.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Общий стиль рамки карточки события.
// Тень — строгая, без размытия.
// ─────────────────────────────────────────────────────────────────────────────

const _cardDecoration = BoxDecoration(
  color: Color(0xFF0E3457),
  border: Border.fromBorderSide(BorderSide(color: Color(0xFF5EA3D3))),
  borderRadius: BorderRadius.all(Radius.circular(UiConstants.borderRadius * 5)),
  boxShadow: [BoxShadow(color: Color(0x99000000), offset: Offset(0, 2))],
);

// ─────────────────────────────────────────────────────────────────────────────
// _EventCard — вертикальная карточка события (как сундук).
// Все размеры пропорциональны высоте карточки через LayoutBuilder.
// ─────────────────────────────────────────────────────────────────────────────

class _EventCard extends StatelessWidget {
  final _EventData event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final h = constraints.maxHeight;

        return DecoratedBox(
          decoration: _cardDecoration,
          child: Padding(
            padding: EdgeInsets.all(h * 0.05),
            child: Column(
              children: [
                // Иконка
                Expanded(
                  flex: 3,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(
                      event.isOrganizer
                          ? Icons.edit_calendar
                          : Icons.sports_esports,
                      color: event.isOrganizer
                          ? const Color(0xFFFFD700)
                          : const Color(0xFF5EA3D3),
                      size: 40,
                    ),
                  ),
                ),
                // Заголовок
                Expanded(
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Clash',
                        fontFamilyFallback: ['Roboto', 'sans-serif'],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Лейблы
                Expanded(
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          event.isOrganizer ? 'организатор' : 'участник',
                          style: TextStyle(
                            fontFamily: 'Clash',
                            fontFamilyFallback: const ['Roboto', 'sans-serif'],
                            fontSize: 12,
                            color: event.isOrganizer
                                ? const Color(0xFFFFD700)
                                : const Color(0xFF5EA3D3),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          event.date,
                          style: TextStyle(
                            fontFamily: 'Clash',
                            fontFamilyFallback: const ['Roboto', 'sans-serif'],
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _EmptyCard — заглушка для пустого слота (< 3 событий).
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyCard extends StatelessWidget {
  const _EmptyCard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0E3457).withValues(alpha: 0.35),
        border: Border.fromBorderSide(
          BorderSide(color: const Color(0xFF5EA3D3).withValues(alpha: 0.3)),
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(UiConstants.borderRadius * 5),
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x44000000), offset: Offset(0, 2)),
        ],
      ),
    );
  }
}
