part of '../../pages/friends_page.dart';

class _UserProfilePlaceholderDialog extends StatelessWidget {
  final _FriendUserData user;

  const _UserProfilePlaceholderDialog({required this.user});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(UiConstants.boxUnit * 2),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(UiConstants.borderRadius * 6),
          border: Border.all(
            color: AppColors.lightStroke,
            width: UiConstants.boxUnit,
          ),
          image: const DecorationImage(
            image: AssetImage('assets/images/background/background.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(UiConstants.boxUnit * 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AvatarSquare(
                    size: UiConstants.boxUnit * 7,
                    imagePathOrUrl: user.avatarUrl,
                    backgroundColor: user.avatarColor,
                    borderRadius: UiConstants.borderRadius * 3,
                    borderColor: AppColors.lightStroke,
                    fallbackText: user.name,
                    fallbackTextWeight: FontWeight.w900,
                  ),
                  const SizedBox(width: UiConstants.boxUnit),
                  Expanded(
                    child: Text(
                      user.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: UiConstants.textSize * 1.15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  GqCloseButton(onTap: () => Navigator.of(context).pop()),
                ],
              ),
              const SizedBox(height: UiConstants.boxUnit),
              Text(
                '${context.l10n.friendsIdPrefix}: ${user.registrationId}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: UiConstants.textSize * 0.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: UiConstants.boxUnit * 1.5),
              Text(
                context.l10n.friendsOpenProfileStubTitle,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: UiConstants.textSize,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: UiConstants.boxUnit),
              Text(
                context.l10n.friendsOpenProfileStubDescription,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: UiConstants.textSize * 0.78,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
