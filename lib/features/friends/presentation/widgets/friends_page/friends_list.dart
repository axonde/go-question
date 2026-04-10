part of '../../pages/friends_page.dart';

class _FriendsRealtimeSection extends StatelessWidget {
  final bool hintsEnabled;
  final bool compactModeEnabled;
  final Profile? currentProfile;
  final IProfileRepository profileRepository;
  final Set<String> pendingFriendRemovalIds;
  final ValueChanged<String> onRemoveFriend;
  final ValueChanged<_FriendUserData> onOpenProfile;

  const _FriendsRealtimeSection({
    required this.hintsEnabled,
    required this.compactModeEnabled,
    required this.currentProfile,
    required this.profileRepository,
    required this.pendingFriendRemovalIds,
    required this.onRemoveFriend,
    required this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Profile>>(
      stream: currentProfile == null
          ? null
          : profileRepository.watchFriends(currentProfile!.uid),
      builder: (context, snapshot) {
        final friends = (snapshot.data ?? const <Profile>[])
            .map(_FriendUserData.fromProfile)
            .toList(growable: false);
        final isLoadingFriends =
            currentProfile != null &&
            snapshot.connectionState == ConnectionState.waiting &&
            friends.isEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.friendsSectionTitle,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: UiConstants.textSize,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '${friends.length} ${context.l10n.friendsCountLabel}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: UiConstants.textSize * 0.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: compactModeEnabled
                  ? UiConstants.boxUnit
                  : UiConstants.boxUnit * 1.5,
            ),
            Expanded(
              child: isLoadingFriends && friends.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(
                        UiConstants.borderRadius * 5,
                      ),
                      child: _FriendsList(
                        hintsEnabled: hintsEnabled,
                        compactModeEnabled: compactModeEnabled,
                        friends: friends,
                        pendingFriendRemovalIds: pendingFriendRemovalIds,
                        onRemoveFriend: onRemoveFriend,
                        onOpenProfile: onOpenProfile,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _FriendsList extends StatelessWidget {
  final bool hintsEnabled;
  final bool compactModeEnabled;
  final List<_FriendUserData> friends;
  final Set<String> pendingFriendRemovalIds;
  final ValueChanged<String> onRemoveFriend;
  final ValueChanged<_FriendUserData> onOpenProfile;

  const _FriendsList({
    required this.hintsEnabled,
    required this.compactModeEnabled,
    required this.friends,
    required this.pendingFriendRemovalIds,
    required this.onRemoveFriend,
    required this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context) {
    if (friends.isEmpty) {
      return _FriendsEmptyState(hintsEnabled: hintsEnabled);
    }

    return ListView.separated(
      key: const PageStorageKey<String>('friends_list'),
      itemCount: friends.length,
      padding: const EdgeInsets.only(bottom: UiConstants.boxUnit * 2),
      separatorBuilder: (_, _) => SizedBox(
        height: compactModeEnabled
            ? UiConstants.boxUnit * 0.75
            : UiConstants.boxUnit,
      ),
      itemBuilder: (_, index) {
        final friend = friends[index];
        return _FriendCard(
          key: ValueKey<String>(friend.id),
          user: friend,
          trailing: FirebaseActionShimmer(
            isLoading: pendingFriendRemovalIds.contains(friend.id),
            borderRadius: UiConstants.borderRadius * 4,
            child: Pressable(
              onTap: () => onRemoveFriend(friend.id),
              child: Container(
                width: UiConstants.boxUnit * 5,
                height: UiConstants.boxUnit * 5,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(
                    UiConstants.borderRadius * 4,
                  ),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: AppColors.textPrimary,
                  size: UiConstants.textSize,
                ),
              ),
            ),
          ),
          onTap: () => onOpenProfile(friend),
        );
      },
    );
  }
}
