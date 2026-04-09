part of '../../pages/friends_page.dart';

class _FriendsPageContent extends StatelessWidget {
  final bool hintsEnabled;
  final bool compactModeEnabled;
  final TextEditingController searchController;
  final _FriendUserData? searchResult;
  final bool hasQuery;
  final Profile? currentProfile;
  final bool isLoadingFriends;
  final List<_FriendUserData> friends;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<_FriendUserData> onAddFriend;
  final ValueChanged<String> onRemoveFriend;
  final ValueChanged<_FriendUserData> onOpenProfile;

  const _FriendsPageContent({
    required this.hintsEnabled,
    required this.compactModeEnabled,
    required this.searchController,
    required this.searchResult,
    required this.hasQuery,
    required this.currentProfile,
    required this.isLoadingFriends,
    required this.friends,
    required this.onSearchChanged,
    required this.onAddFriend,
    required this.onRemoveFriend,
    required this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = compactModeEnabled
        ? UiConstants.horizontalPadding * 1.5
        : UiConstants.horizontalPadding * 2;
    final topPadding = compactModeEnabled
        ? UiConstants.topPadding * 1.5
        : UiConstants.topPadding * 2;
    final sectionGap = compactModeEnabled
        ? UiConstants.boxUnit * 1.25
        : UiConstants.boxUnit * 2;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        topPadding,
        horizontalPadding,
        compactModeEnabled
            ? UiConstants.bottomPadding * 1.5
            : UiConstants.bottomPadding * 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            FriendsTexts.pageTitle,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: UiConstants.textSize * 1.35,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: sectionGap),
          _FriendsSearchPanel(
            hintsEnabled: hintsEnabled,
            compactModeEnabled: compactModeEnabled,
            controller: searchController,
            searchResult: searchResult,
            hasQuery: hasQuery,
            currentProfile: currentProfile,
            onChanged: onSearchChanged,
            onAddFriend: onAddFriend,
            onOpenProfile: onOpenProfile,
          ),
          SizedBox(height: sectionGap),
          Row(
            children: [
              const Expanded(
                child: Text(
                  FriendsTexts.friendsSectionTitle,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: UiConstants.textSize,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${friends.length} ${FriendsTexts.friendCountLabel}',
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
                : _FriendsList(
                    hintsEnabled: hintsEnabled,
                    compactModeEnabled: compactModeEnabled,
                    friends: friends,
                    onRemoveFriend: onRemoveFriend,
                    onOpenProfile: onOpenProfile,
                  ),
          ),
        ],
      ),
    );
  }
}
