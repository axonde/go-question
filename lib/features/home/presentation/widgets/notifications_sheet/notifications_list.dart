part of '../notifications_sheet.dart';

class _NotificationsList extends StatelessWidget {
  final List<NotificationData> notifications;
  final Set<String> processingIds;
  final String? expandedNotificationId;
  final ValueChanged<NotificationData> onToggle;
  final Future<void> Function(NotificationData) onAccept;
  final Future<void> Function(NotificationData) onReject;

  const _NotificationsList({
    required this.notifications,
    required this.processingIds,
    required this.expandedNotificationId,
    required this.onToggle,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final unreadNotifications = notifications
        .where((notification) => !notification.isRead)
        .toList(growable: false);
    final readNotifications = notifications
        .where((notification) => notification.isRead)
        .toList(growable: false);

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(UiConstants.horizontalPadding * 2),
        children: [
          if (unreadNotifications.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: UiConstants.boxUnit),
              child: Text(
                context.l10n.notificationsUnreadSectionTitle,
                style: const TextStyle(
                  fontFamily: 'RussoOne',
                  fontSize: UiConstants.textSize * 0.75,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ..._buildCards(unreadNotifications),
          ..._buildCards(readNotifications),
        ],
      ),
    );
  }

  List<Widget> _buildCards(List<NotificationData> items) {
    return items
        .map(
          (data) => Padding(
            padding: const EdgeInsets.only(bottom: UiConstants.boxUnit * 1.5),
            child: FirebaseActionShimmer(
              isLoading: processingIds.contains(data.id),
              child: NotificationCard(
                data: data,
                isLoading: processingIds.contains(data.id),
                isExpanded: expandedNotificationId == data.id,
                onToggle: () => onToggle(data),
                onAccept: data.showAccept ? () => onAccept(data) : null,
                onReject: data.showReject ? () => onReject(data) : null,
              ),
            ),
          ),
        )
        .toList(growable: false);
  }
}
