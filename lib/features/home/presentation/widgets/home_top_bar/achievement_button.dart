part of '../home_top_bar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// _AchievementButton — квадратная кнопка достижений.
// Скрывается целиком когда [visible] == false.
// Собственный стиль: фон 0xFF257FB4, обводка чёрная.
// ─────────────────────────────────────────────────────────────────────────────

const _achievementDecoration = BoxDecoration(
  color: HomeUiConstants.achievementBackground,
  border: Border.fromBorderSide(BorderSide()),
  borderRadius: BorderRadius.all(Radius.circular(UiConstants.borderRadius * 5)),
  boxShadow: [
    BoxShadow(
      color: HomeUiConstants.panelShadow,
      offset: Offset(0, HomeUiConstants.cardShadowOffset),
    ),
  ],
);

class _AchievementButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool visible;
  final bool hasUnreadAchievements;
  final double height;

  const _AchievementButton({
    required this.onTap,
    required this.height,
    this.visible = true,
    this.hasUnreadAchievements = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return Pressable(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: height,
            height: height,
            decoration: _achievementDecoration,
            child: Icon(
              Icons.military_tech,
              color: HomeUiConstants.achievementIcon,
              size: height * 0.6,
            ),
          ),
          if (hasUnreadAchievements)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: HomeUiConstants.achievementUnreadDot,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
