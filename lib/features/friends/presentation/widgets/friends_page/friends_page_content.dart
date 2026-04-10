part of '../../pages/friends_page.dart';

class _FriendsPageContent extends StatelessWidget {
  final bool hintsEnabled;
  final bool compactModeEnabled;
  final TextEditingController searchController;
  final _FriendUserData? searchResult;
  final bool hasQuery;
  final Profile? currentProfile;
  final IProfileRepository profileRepository;
  final Set<String> pendingFriendRequestIds;
  final Set<String> pendingFriendRemovalIds;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onRequireRegistration;
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
    required this.profileRepository,
    required this.pendingFriendRequestIds,
    required this.pendingFriendRemovalIds,
    required this.onSearchChanged,
    required this.onRequireRegistration,
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
          Text(
            context.l10n.friendsPageTitle,
            style: const TextStyle(
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
            canSearch: currentProfile != null,
            currentProfile: currentProfile,
            pendingFriendRequestIds: pendingFriendRequestIds,
            onChanged: onSearchChanged,
            onRequireRegistration: onRequireRegistration,
            onAddFriend: onAddFriend,
            onOpenProfile: onOpenProfile,
          ),
          SizedBox(height: sectionGap),
          Expanded(
            child: _FriendsRealtimeSection(
              hintsEnabled: hintsEnabled,
              compactModeEnabled: compactModeEnabled,
              currentProfile: currentProfile,
              profileRepository: profileRepository,
              pendingFriendRemovalIds: pendingFriendRemovalIds,
              onRemoveFriend: onRemoveFriend,
              onOpenProfile: onOpenProfile,
            ),
          ),
        ],
      ),
    );
  }
}
