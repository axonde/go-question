part of '../profile_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// _ProfileAvatar — единственная ответственность: квадрат с аватаркой.
// Размер передаётся снаружи → адаптируется к любому экрану.
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileAvatar extends StatelessWidget {
  final double size;
  final String? avatarUrl;

  const _ProfileAvatar({required this.size, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return AvatarSquare(
      size: size,
      imagePathOrUrl: avatarUrl,
      borderRadius: size * 0.2,
      borderColor: Colors.white.withValues(alpha: 0.65),
      fallbackAssetPath: ProfilePresentationConstants.defaultAvatarPath,
    );
  }
}
