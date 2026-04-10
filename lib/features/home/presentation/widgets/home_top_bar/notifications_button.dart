part of '../home_top_bar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// _NotificationsButton — кнопка уведомлений в стиле GQButton (зелёная).
// LayoutBuilder берёт реальную ширину от Flexible-родителя и передаёт в GQButton.
// ─────────────────────────────────────────────────────────────────────────────

class _NotificationsButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool hasUnreadNotifications;
  final double height;

  const _NotificationsButton({
    required this.onTap,
    required this.height,
    this.hasUnreadNotifications = false,
  });

  @override
  Widget build(BuildContext context) {
    final adjustedHeight = height;

    return LayoutBuilder(
      builder: (_, constraints) => Stack(
        clipBehavior: Clip.none,
        children: [
          GQButton(
            onPressed: onTap,
            text: context.l10n.homeNotificationsButton,
            fontSize: UiConstants.textSize,
            baseColor: HomeUiConstants.notificationButtonBackground,
            width: constraints.maxWidth,
            height: adjustedHeight,
          ),
          if (hasUnreadNotifications)
            const Positioned(
              top: -2,
              right: -2,
              child: _UnreadNotificationsBadge(),
            ),
        ],
      ),
    );
  }
}

class _UnreadNotificationsBadge extends StatelessWidget {
  const _UnreadNotificationsBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: HomeUiConstants.achievementUnreadDot,
        shape: BoxShape.circle,
      ),
    );
  }
}
