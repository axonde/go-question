part of '../notifications_sheet.dart';

class _NotificationsList extends StatelessWidget {
  final List<NotificationData> notifications;
  final int? expandedIndex;
  final ValueChanged<int> onToggle;

  const _NotificationsList({
    required this.notifications,
    required this.expandedIndex,
    required this.onToggle,
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
          );
        },
      ),
    );
  }
}
