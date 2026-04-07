part of '../profile_screen.dart';

class _Profile extends StatelessWidget {
  final String name;

  const _Profile({required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: UiConstants.topPadding * 3,
        bottom: UiConstants.bottomPadding * 3,
      ),
      child: Text(name, style: AppTextStyles.bodyLarge),
    );
  }
}
