part of '../../home_events.dart';

class _EventDetailsDialog extends StatelessWidget {
  final _EventCardData eventCardData;

  const _EventDetailsDialog({required this.eventCardData});

  @override
  Widget build(BuildContext context) {
    final event = eventCardData.event;
    final isOrganizer = eventCardData.viewerRole == EventViewerRole.organizer;
    final priceLabel = event.price == 0
        ? EventTexts.filterFree
        : '${event.price.toInt()} ${EventTexts.currencyRub}';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(UiConstants.boxUnit * 2),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF0E3457),
          borderRadius: BorderRadius.circular(UiConstants.borderRadius * 6),
          border: Border.all(color: const Color(0xFF5EA3D3)),
          boxShadow: const [
            BoxShadow(
              color: Color(0xAA000000),
              offset: Offset(0, UiConstants.shadowOffsetY),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(UiConstants.boxUnit * 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: EventTexts.fontClash,
                        fontFamilyFallback: EventTexts.fontFallback,
                        fontSize: UiConstants.textSize * 1.1,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GqCloseButton(onTap: () => Navigator.of(context).pop()),
                ],
              ),
              const SizedBox(height: UiConstants.boxUnit * 1.5),
              _DetailLine(
                label: EventTexts.createFieldStart,
                value: EventPresentationUtils.formatLongDateTime(
                  event.startTime,
                ),
              ),
              _DetailLine(
                label: EventTexts.createFieldLocation,
                value: event.location,
              ),
              _DetailLine(
                label: EventTexts.createFieldCategory,
                value: event.category,
              ),
              _DetailLine(
                label: EventTexts.createFieldMaxUsers,
                value:
                    '${event.participants}/${event.maxUsers} ${EventTexts.participantsWord}',
              ),
              _DetailLine(
                label: EventTexts.createFieldPrice,
                value: priceLabel,
              ),
              const SizedBox(height: UiConstants.boxUnit * 1.25),
              Text(
                event.description,
                style: const TextStyle(
                  fontFamily: EventTexts.fontClash,
                  fontFamilyFallback: EventTexts.fontFallback,
                  fontSize: UiConstants.textSize * 0.72,
                  color: Color(0xFFD8E7F8),
                ),
              ),
              const SizedBox(height: UiConstants.boxUnit * 1.5),
              if (isOrganizer) ...[
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        text: EventTexts.buttonParticipants,
                        baseColor: const Color(0xFFFFC00F),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                EventTexts.snackBarParticipantsList,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: UiConstants.boxUnit),
                    Expanded(
                      child: _ActionButton(
                        text: EventTexts.buttonEdit,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(EventTexts.snackBarEditEvent),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ] else ...[
                _ActionButton(
                  text: EventTexts.buttonLeaveEvent,
                  baseColor: const Color(0xFFC62828),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(EventTexts.snackBarLeftEvent),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
