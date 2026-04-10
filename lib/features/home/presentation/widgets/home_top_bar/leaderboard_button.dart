part of '../home_top_bar.dart';

class _LeaderboardButton extends StatelessWidget {
  final VoidCallback onTap;
  final double height;

  const _LeaderboardButton({required this.onTap, required this.height});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: _frameDecoration,
        alignment: Alignment.center,
        child: Icon(
          Icons.workspace_premium_rounded,
          color: HomeUiConstants.achievementIcon,
          size: height * 0.58,
        ),
      ),
    );
  }
}
