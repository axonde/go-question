part of '../../pages/friends_page.dart';

class _FriendsSearchPanel extends StatelessWidget {
  final bool hintsEnabled;
  final bool compactModeEnabled;
  final TextEditingController controller;
  final _FriendUserData? searchResult;
  final bool hasQuery;
  final bool canSearch;
  final Profile? currentProfile;
  final Set<String> pendingFriendRequestIds;
  final ValueChanged<String> onChanged;
  final VoidCallback onRequireRegistration;
  final ValueChanged<_FriendUserData> onAddFriend;
  final ValueChanged<_FriendUserData> onOpenProfile;

  const _FriendsSearchPanel({
    required this.hintsEnabled,
    required this.compactModeEnabled,
    required this.controller,
    required this.searchResult,
    required this.hasQuery,
    required this.canSearch,
    required this.currentProfile,
    required this.pendingFriendRequestIds,
    required this.onChanged,
    required this.onRequireRegistration,
    required this.onAddFriend,
    required this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FriendsUiConstants.panelBackground.withValues(alpha: 0.74),
        border: Border.all(color: FriendsUiConstants.panelBorder),
        borderRadius: BorderRadius.circular(UiConstants.borderRadius * 5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: FriendsUiConstants.panelShadowAlpha,
            ),
            offset: const Offset(0, UiConstants.shadowOffsetY),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(
          compactModeEnabled
              ? UiConstants.boxUnit * 1.25
              : UiConstants.boxUnit * 1.5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.friendsSearchSectionTitle,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: UiConstants.textSize * 0.9,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: compactModeEnabled
                  ? UiConstants.boxUnit * 0.75
                  : UiConstants.boxUnit,
            ),
            TextField(
              controller: controller,
              readOnly: !canSearch,
              onTap: canSearch ? null : onRequireRegistration,
              onChanged: canSearch ? onChanged : null,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(color: AppColors.textPrimary),
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              decoration: InputDecoration(
                hintText: context.l10n.friendsSearchHint,
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.inputBackground,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: UiConstants.horizontalPadding * 2,
                  vertical: UiConstants.verticalPadding * 1.5,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    UiConstants.borderRadius * 4,
                  ),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    UiConstants.borderRadius * 4,
                  ),
                  borderSide: const BorderSide(color: AppColors.inputFocused),
                ),
              ),
            ),
            SizedBox(
              height: compactModeEnabled
                  ? UiConstants.boxUnit
                  : UiConstants.boxUnit * 1.5,
            ),
            _FriendsSearchResult(
              hintsEnabled: hintsEnabled,
              searchResult: searchResult,
              hasQuery: canSearch && hasQuery,
              currentProfile: currentProfile,
              pendingFriendRequestIds: pendingFriendRequestIds,
              onAddFriend: onAddFriend,
              onOpenProfile: onOpenProfile,
            ),
          ],
        ),
      ),
    );
  }
}
