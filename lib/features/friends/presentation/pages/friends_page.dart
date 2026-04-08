import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/friends_texts.dart';
import 'package:go_question/core/widgets/buttons/gq_close_button.dart';
import 'package:go_question/core/widgets/pressable.dart';

part '../widgets/friends_page/friends_page_content.dart';
part '../widgets/friends_page/friends_search_panel.dart';
part '../widgets/friends_page/friends_search_result.dart';
part '../widgets/friends_page/friends_list.dart';
part '../widgets/friends_page/friend_card.dart';
part '../widgets/friends_page/friends_empty_state.dart';
part '../widgets/friends_page/user_profile_placeholder_dialog.dart';

class FriendsPage extends StatefulWidget {
  final bool hintsEnabled;
  final bool compactModeEnabled;

  const FriendsPage({
    super.key,
    this.hintsEnabled = true,
    this.compactModeEnabled = false,
  });

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final TextEditingController _searchController = TextEditingController();
  late final List<_FriendUserData> _allUsers = List<_FriendUserData>.of(
    _mockUsers,
  );
  late final List<_FriendUserData> _friends = _allUsers
      .where((user) => _initialFriendIds.contains(user.id))
      .toList();

  String get _query => _searchController.text.trim();

  _FriendUserData? get _searchResult {
    if (_query.isEmpty) {
      return null;
    }

    final normalizedQuery = _query.toLowerCase();

    for (final user in _allUsers) {
      if (user.id.toLowerCase().contains(normalizedQuery)) {
        return user;
      }
    }

    return null;
  }

  bool _isFriend(String userId) =>
      _friends.any((friend) => friend.id == userId);

  void _addFriend(_FriendUserData user) {
    if (_isFriend(user.id)) {
      return;
    }

    setState(() {
      _friends.insert(0, user);
    });
  }

  void _removeFriend(String userId) {
    setState(() {
      _friends.removeWhere((friend) => friend.id == userId);
    });
  }

  void _openProfilePreview(_FriendUserData user) {
    showDialog<void>(
      context: context,
      builder: (_) => _UserProfilePlaceholderDialog(user: user),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: _FriendsPageContent(
          hintsEnabled: widget.hintsEnabled,
          compactModeEnabled: widget.compactModeEnabled,
          searchController: _searchController,
          searchResult: _searchResult,
          hasQuery: _query.isNotEmpty,
          isAlreadyFriend:
              _searchResult != null && _isFriend(_searchResult!.id),
          friends: _friends,
          onSearchChanged: (_) => setState(() {}),
          onAddFriend: _addFriend,
          onRemoveFriend: _removeFriend,
          onOpenProfile: _openProfilePreview,
        ),
      ),
    );
  }
}

class _FriendUserData {
  final String id;
  final String name;
  final String city;
  final int level;
  final Color avatarColor;

  const _FriendUserData({
    required this.id,
    required this.name,
    required this.city,
    required this.level,
    required this.avatarColor,
  });
}

const _initialFriendIds = <String>{'GO-1042', 'GO-2140', 'GO-7711'};

const _mockUsers = <_FriendUserData>[
  _FriendUserData(
    id: 'GO-1042',
    name: 'Максим Лебедев',
    city: 'Санкт-Петербург',
    level: 14,
    avatarColor: Color(0xFF5EA3D3),
  ),
  _FriendUserData(
    id: 'GO-2140',
    name: 'Арина Шульга',
    city: 'Москва',
    level: 11,
    avatarColor: Color(0xFFFFC00F),
  ),
  _FriendUserData(
    id: 'GO-7711',
    name: 'Егор Савчук',
    city: 'Казань',
    level: 9,
    avatarColor: Color(0xFF57D6A4),
  ),
  _FriendUserData(
    id: 'GO-9910',
    name: 'Дарья Ким',
    city: 'Сочи',
    level: 16,
    avatarColor: Color(0xFFFC7E6B),
  ),
  _FriendUserData(
    id: 'GO-5521',
    name: 'Никита Воронов',
    city: 'Екатеринбург',
    level: 7,
    avatarColor: Color(0xFF9E84FF),
  ),
];
