part of '../../pages/friends_page.dart';

class _FriendsSearchResult extends StatelessWidget {
  final bool hintsEnabled;
  final _FriendUserData? searchResult;
  final bool hasQuery;
  final bool isAlreadyFriend;
  final ValueChanged<_FriendUserData> onAddFriend;
  final ValueChanged<_FriendUserData> onOpenProfile;

  const _FriendsSearchResult({
    required this.hintsEnabled,
    required this.searchResult,
    required this.hasQuery,
    required this.isAlreadyFriend,
    required this.onAddFriend,
    required this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasQuery) {
      return hintsEnabled
          ? const Text(
              FriendsTexts.searchEmpty,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: UiConstants.textSize * 0.78,
                fontWeight: FontWeight.w600,
              ),
            )
          : const SizedBox.shrink();
    }

    if (searchResult == null) {
      return const Text(
        FriendsTexts.searchNotFound,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: UiConstants.textSize * 0.78,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return _FriendCard(
      user: searchResult!,
      trailing: isAlreadyFriend
          ? Container(
              constraints: const BoxConstraints(
                minWidth: UiConstants.boxUnit * 11,
                maxWidth: UiConstants.boxUnit * 14,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: UiConstants.horizontalPadding * 1.5,
                vertical: UiConstants.verticalPadding,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(
                  UiConstants.borderRadius * 4,
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: const Text(
                FriendsTexts.alreadyFriend,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: UiConstants.textSize * 0.65,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : Pressable(
              onTap: () => onAddFriend(searchResult!),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: UiConstants.horizontalPadding * 1.75,
                  vertical: UiConstants.verticalPadding * 1.25,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(
                    UiConstants.borderRadius * 4,
                  ),
                  border: Border.all(color: AppColors.secondaryVariant),
                ),
                child: const Text(
                  FriendsTexts.addFriend,
                  style: TextStyle(
                    color: AppColors.stroke,
                    fontSize: UiConstants.textSize * 0.72,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
      onTap: () => onOpenProfile(searchResult!),
    );
  }
}
