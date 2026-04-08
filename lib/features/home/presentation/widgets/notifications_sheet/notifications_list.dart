part of '../notifications_sheet.dart';

class _NotificationsList extends StatelessWidget {
  final List<NotificationData> notifications;

  const _NotificationsList({
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: ListView.separated(
        padding: const EdgeInsets.all(UiConstants.horizontalPadding * 2),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final data = notifications[index];
          return NotificationCard(data: data);
        },
      ),
    );
  }
}
