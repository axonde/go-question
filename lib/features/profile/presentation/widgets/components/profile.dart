part of '../profile_screen.dart';

class _Profile extends StatelessWidget {
  final String name;
  final int registrationId;

  const _Profile({required this.name, required this.registrationId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: UiConstants.topPadding * 3,
        bottom: UiConstants.bottomPadding * 3,
      ),
      child: Column(
        spacing: UiConstants.gap * 2,
        children: [
          Text(name, style: AppTextStyles.bodyMedium),
          Text('ID: $registrationId', style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }
}
