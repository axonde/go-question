part of '../home_top_bar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// _AchievementButton — квадратная кнопка достижений.
// Скрывается целиком когда [visible] == false.
// Собственный стиль: фон 0xFF257FB4, обводка чёрная.
// ─────────────────────────────────────────────────────────────────────────────

const _achievementDecoration = BoxDecoration(
  color: Color(0xFF257FB4),
  border: Border.fromBorderSide(
    BorderSide(color: Colors.black, width: UiConstants.borderWidth / 2),
  ),
  borderRadius: BorderRadius.all(Radius.circular(UiConstants.borderRadius * 5)),
  boxShadow: [
    BoxShadow(
      color: Color(0x99000000),
      blurRadius: 0,
      spreadRadius: 0,
      offset: Offset(0, 2),
    ),
  ],
);

class _AchievementButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool visible;
  final double height;

  const _AchievementButton({required this.onTap, required this.height, this.visible = true});

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return Pressable(
      onTap: onTap,
      child: Container(
        width: height,
        height: height,
        decoration: _achievementDecoration,
        child: Icon(
          Icons.military_tech,
          color: const Color(0xFFFFD700),
          size: height * 0.6,
        ),
      ),
    );
  }
}
