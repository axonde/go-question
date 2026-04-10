part of '../profile_screen.dart';

class _Avatar extends StatelessWidget {
  final String? avatarUrl;
  final VoidCallback onTap;

  const _Avatar({required this.avatarUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: AvatarSquare(
        size: UiConstants.boxUnit * 13,
        imagePathOrUrl: avatarUrl,
        borderRadius: UiConstants.borderRadius * 3.5,
        borderColor: AppColors.lightStroke,
        borderWidth: UiConstants.strokeWidth * 1.5,
        fallbackAssetPath: ProfilePresentationConstants.defaultAvatarPath,
      ),
    );
  }
}
