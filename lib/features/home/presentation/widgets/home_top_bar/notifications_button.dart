part of '../home_top_bar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// _NotificationsButton — кнопка уведомлений в стиле GQButton (зелёная).
// LayoutBuilder берёт реальную ширину от Flexible-родителя и передаёт в GQButton.
// ─────────────────────────────────────────────────────────────────────────────

class _NotificationsButton extends StatelessWidget {
  final VoidCallback onTap;
  final double height;

  const _NotificationsButton({required this.onTap, required this.height});

  @override
  Widget build(BuildContext context) {
    final adjustedHeight = height;

    return LayoutBuilder(
      builder: (_, constraints) => GQButton(
        onPressed: onTap,
        text: 'Уведомления',
        fontSize: UiConstants.textSize,
        baseColor: HomeUiConstants.notificationButtonBackground,
        width: constraints.maxWidth,
        height: adjustedHeight,
      ),
    );
  }
}
