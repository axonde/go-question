part of '../notifications_sheet.dart';

class _NotificationsList extends StatelessWidget {
  final List<NotificationData> notifications;
  final int? expandedIndex;
  final ValueChanged<int> onToggle;
  final Future<void> Function(NotificationData) onAccept;
  final Future<void> Function(NotificationData) onReject;

  const _NotificationsList({
    required this.notifications,
    required this.expandedIndex,
    required this.onToggle,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: ListView.separated(
        padding: const EdgeInsets.all(UiConstants.horizontalPadding * 2),
        itemCount: notifications.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: UiConstants.boxUnit * 1.5),
        itemBuilder: (context, index) {
          final data = notifications[index];
          return NotificationCard(
            data: data,
            isExpanded: expandedIndex == index,
            onToggle: () => onToggle(index),
            onAccept: data.showAccept ? () => onAccept(data) : null,
            onReject: data.showReject ? () => onReject(data) : null,
          );
        },
      ),
    );
  }
}
