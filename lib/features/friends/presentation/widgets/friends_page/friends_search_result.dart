part of '../../pages/friends_page.dart';

class _FriendsSearchResult extends StatelessWidget {
  final bool hintsEnabled;
  final _FriendUserData? searchResult;
  final bool hasQuery;
  final Profile? currentProfile;
  final ValueChanged<_FriendUserData> onAddFriend;
  final ValueChanged<_FriendUserData> onOpenProfile;

  const _FriendsSearchResult({
    required this.hintsEnabled,
    required this.searchResult,
    required this.hasQuery,
    required this.currentProfile,
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

    final currentUserId = context.read<ProfileBloc>().state.profile?.uid ?? '';
    final actionLabel = FriendRelationUtils.actionLabel(
      currentProfile: currentProfile,
      currentUserId: currentUserId,
      otherUid: searchResult!.id,
    );
    final canSendRequest = FriendRelationUtils.canSendRequest(
      currentProfile: currentProfile,
      currentUserId: currentUserId,
      otherUid: searchResult!.id,
    );
    final trailing = actionLabel == FriendsTexts.alreadyFriend
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
              color: FriendsUiConstants.alreadyFriendBackground,
              borderRadius: BorderRadius.circular(UiConstants.borderRadius * 4),
              border: Border.all(color: FriendsUiConstants.alreadyFriendBorder),
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
        : canSendRequest
        ? Pressable(
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
                  color: FriendsUiConstants.avatarText,
                  fontSize: UiConstants.textSize * 0.72,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(
              horizontal: UiConstants.horizontalPadding * 1.75,
              vertical: UiConstants.verticalPadding * 1.25,
            ),
            decoration: BoxDecoration(
              color: FriendsUiConstants.alreadyFriendBackground,
              borderRadius: BorderRadius.circular(UiConstants.borderRadius * 4),
              border: Border.all(color: FriendsUiConstants.alreadyFriendBorder),
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: UiConstants.textSize * 0.72,
                fontWeight: FontWeight.w900,
              ),
            ),
          );

    return _FriendCard(
      user: searchResult!,
      trailing: trailing,
      onTap: () => onOpenProfile(searchResult!),
    );
  }
}
