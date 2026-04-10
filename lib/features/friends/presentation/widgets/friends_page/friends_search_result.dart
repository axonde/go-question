part of '../../pages/friends_page.dart';

class _FriendsSearchResult extends StatelessWidget {
  final bool hintsEnabled;
  final _FriendUserData? searchResult;
  final bool hasQuery;
  final Profile? currentProfile;
  final Set<String> pendingFriendRequestIds;
  final ValueChanged<_FriendUserData> onAddFriend;
  final ValueChanged<_FriendUserData> onOpenProfile;

  const _FriendsSearchResult({
    required this.hintsEnabled,
    required this.searchResult,
    required this.hasQuery,
    required this.currentProfile,
    required this.pendingFriendRequestIds,
    required this.onAddFriend,
    required this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (!hasQuery) {
      return hintsEnabled
          ? Text(
              l10n.friendsSearchEmpty,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: UiConstants.textSize * 0.78,
                fontWeight: FontWeight.w600,
              ),
            )
          : const SizedBox.shrink();
    }

    if (searchResult == null) {
      return Text(
        l10n.friendsSearchNotFound,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: UiConstants.textSize * 0.78,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    final currentUserId = context.read<ProfileBloc>().state.profile?.uid ?? '';
    final isSelf =
        currentUserId.isNotEmpty && currentUserId == searchResult!.id;
    final isFriend = FriendRelationUtils.isFriend(
      currentProfile: currentProfile,
      otherUid: searchResult!.id,
    );
    final isOutgoingPending = FriendRelationUtils.isOutgoingRequestPending(
      currentProfile: currentProfile,
      currentUserId: currentUserId,
      otherUid: searchResult!.id,
    );
    final isIncomingPending = FriendRelationUtils.isIncomingRequestPending(
      currentProfile: currentProfile,
      currentUserId: currentUserId,
      otherUid: searchResult!.id,
    );

    final actionLabel = isSelf
        ? l10n.friendsSelfAccount
        : isFriend
        ? l10n.friendsAlreadyFriend
        : isOutgoingPending
        ? l10n.friendsRequestPending
        : isIncomingPending
        ? l10n.friendsRequestIncoming
        : l10n.friendsAddFriend;

    final canSendRequest = FriendRelationUtils.canSendRequest(
      currentProfile: currentProfile,
      currentUserId: currentUserId,
      otherUid: searchResult!.id,
    );
    final isPendingAction = pendingFriendRequestIds.contains(searchResult!.id);
    final trailing = isFriend
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
            child: Text(
              l10n.friendsAlreadyFriend,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: UiConstants.textSize * 0.65,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        : canSendRequest
        ? FirebaseActionShimmer(
            isLoading: isPendingAction,
            borderRadius: UiConstants.borderRadius * 4,
            child: Pressable(
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
                child: Text(
                  l10n.friendsAddFriend,
                  style: const TextStyle(
                    color: FriendsUiConstants.avatarText,
                    fontSize: UiConstants.textSize * 0.72,
                    fontWeight: FontWeight.w900,
                  ),
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
