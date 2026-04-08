part of '../../home_events.dart';

class _EventCard extends StatelessWidget {
  final _EventCardData eventCardData;

  const _EventCard({required this.eventCardData});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final h = constraints.maxHeight;
        final event = eventCardData.event;
        final isOrganizer =
            eventCardData.viewerRole == EventViewerRole.organizer;

        return GestureDetector(
          onTap: () => showDialog<void>(
            context: context,
            builder: (_) => _EventDetailsDialog(eventCardData: eventCardData),
          ),
          child: DecoratedBox(
            decoration: _cardDecoration,
            child: Padding(
              padding: EdgeInsets.all(h * 0.05),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Icon(
                        isOrganizer
                            ? Icons.edit_calendar
                            : Icons.sports_esports,
                        color: isOrganizer
                            ? const Color(0xFFFFD700)
                            : const Color(0xFF5EA3D3),
                        size: 40,
                      ),
                    ),
                  ),
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
                          fontFamily: EventTexts.fontClash,
                          fontFamilyFallback: EventTexts.fontFallback,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isOrganizer
                                ? EventTexts.roleOrganizer
                                : EventTexts.roleParticipant,
                            style: TextStyle(
                              fontFamily: EventTexts.fontClash,
                              fontFamilyFallback: EventTexts.fontFallback,
                              fontSize: 12,
                              color: isOrganizer
                                  ? const Color(0xFFFFD700)
                                  : const Color(0xFF5EA3D3),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            EventPresentationUtils.formatShortDateTime(
                              event.startTime,
                            ),
                            style: TextStyle(
                              fontFamily: EventTexts.fontClash,
                              fontFamilyFallback: EventTexts.fontFallback,
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
          ),
        );
      },
    );
  }
}
