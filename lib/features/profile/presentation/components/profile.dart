part of '../profile_screen.dart';

class _Profile extends StatelessWidget {
  String name;
  String nick;

  _Profile({required this.name, required this.nick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: UiConstants.topPadding * 3,
        bottom: UiConstants.bottomPadding * 3,
      ),
      child: Column(
        spacing: UiConstants.gap * 2,
        children: [
          Text(name, style: AppTextStyles.bodyLarge),
          Text('@$nick', style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
