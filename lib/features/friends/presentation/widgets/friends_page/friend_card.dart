part of '../../pages/friends_page.dart';

class _FriendCard extends StatelessWidget {
  final _FriendUserData user;
  final Widget trailing;
  final VoidCallback onTap;

  const _FriendCard({
    super.key,
    required this.user,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: FriendsUiConstants.panelBackground.withValues(alpha: 0.72),
          border: Border.all(color: FriendsUiConstants.panelBorder),
          borderRadius: BorderRadius.circular(UiConstants.borderRadius * 5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: FriendsUiConstants.cardShadowAlpha,
              ),
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UiConstants.horizontalPadding * 1.5,
            vertical: UiConstants.verticalPadding * 1.5,
          ),
          child: Row(
            children: [
              AvatarSquare(
                size: UiConstants.boxUnit * 7,
                imagePathOrUrl: user.avatarUrl,
                backgroundColor: user.avatarColor,
                borderRadius: UiConstants.borderRadius * 3,
                borderColor: FriendsUiConstants.avatarBorder,
                fallbackText: user.name.isEmpty ? '?' : user.name[0],
                fallbackTextSize: UiConstants.textSize * 1.1,
                fallbackTextWeight: FontWeight.w900,
              ),
              const SizedBox(width: UiConstants.boxUnit * 1.5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: UiConstants.textSize * 0.92,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: UiConstants.boxUnit * 0.5),
                    Text(
                      '${context.l10n.friendsIdPrefix}: ${user.registrationId}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: UiConstants.textSize * 0.7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: UiConstants.boxUnit * 0.25),
                    Text(
                      '${context.l10n.friendsCityPrefix}: ${user.city.isEmpty ? context.l10n.friendsCityFallback : user.city}  •  '
                      '${context.l10n.friendsLevelPrefix}: ${user.level}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: UiConstants.textSize * 0.68,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: UiConstants.boxUnit),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
