part of '../../pages/friends_page.dart';

class _FriendsList extends StatelessWidget {
  final bool hintsEnabled;
  final bool compactModeEnabled;
  final List<_FriendUserData> friends;
  final ValueChanged<String> onRemoveFriend;
  final ValueChanged<_FriendUserData> onOpenProfile;

  const _FriendsList({
    required this.hintsEnabled,
    required this.compactModeEnabled,
    required this.friends,
    required this.onRemoveFriend,
    required this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context) {
    if (friends.isEmpty) {
      return _FriendsEmptyState(hintsEnabled: hintsEnabled);
    }

    return ListView.separated(
      itemCount: friends.length,
      clipBehavior: Clip.none,
      separatorBuilder: (_, _) => SizedBox(
        height: compactModeEnabled
            ? UiConstants.boxUnit * 0.75
            : UiConstants.boxUnit,
      ),
      itemBuilder: (_, index) {
        final friend = friends[index];
        return _FriendCard(
          user: friend,
          trailing: Pressable(
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
          onTap: () => onOpenProfile(friend),
        );
      },
    );
  }
}
