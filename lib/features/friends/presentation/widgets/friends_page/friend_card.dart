part of '../../pages/friends_page.dart';

class _FriendCard extends StatelessWidget {
  final _FriendUserData user;
  final Widget trailing;
  final VoidCallback onTap;

  const _FriendCard({
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
          color: const Color(0xFF0E3457).withValues(alpha: 0.72),
          border: Border.all(color: const Color(0xFF5EA3D3)),
          borderRadius: BorderRadius.circular(UiConstants.borderRadius * 5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
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
              Container(
                width: UiConstants.boxUnit * 7,
                height: UiConstants.boxUnit * 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: user.avatarColor,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  user.name.isEmpty ? '?' : user.name[0],
                  style: const TextStyle(
                    color: AppColors.stroke,
                    fontSize: UiConstants.textSize * 1.1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
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
                      '${FriendsTexts.friendIdPrefix}: ${user.id}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: UiConstants.textSize * 0.7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: UiConstants.boxUnit * 0.25),
                    Text(
                      '${FriendsTexts.cityPrefix}: ${user.city}  •  '
                      '${FriendsTexts.levelPrefix}: ${user.level}',
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
