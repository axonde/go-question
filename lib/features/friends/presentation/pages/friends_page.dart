import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/friends_texts.dart';
import 'package:go_question/core/constants/friends_ui_constants.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/core/widgets/buttons/gq_close_button.dart';
import 'package:go_question/core/widgets/pressable.dart';
import 'package:go_question/features/profile/domain/entities/profile.dart';
import 'package:go_question/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:go_question/injection_container/injection_container.dart';

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
  final IProfileRepository _profileRepository = sl<IProfileRepository>();
  List<_FriendUserData> _friends = [];
  _FriendUserData? _searchResult;
  String? _currentUserId;
  bool _isLoadingFriends = true;

  String get _query => _searchController.text.trim();

  bool _isFriend(String userId) =>
      _friends.any((friend) => friend.id == userId);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFriends());
  }

  Future<void> _loadFriends() async {
    final profile = context.read<ProfileBloc>().state.profile;
    if (profile == null || !mounted) {
      setState(() => _isLoadingFriends = false);
      return;
    }

    _currentUserId = profile.uid;

    final result = await _profileRepository.getFriends(profile.uid);
    if (!mounted) return;

    result.fold(
      onSuccess: (friends) {
        setState(() {
          _friends = friends.map(_FriendUserData.fromProfile).toList();
          _isLoadingFriends = false;
        });
      },
      onFailure: (_) {
        setState(() => _isLoadingFriends = false);
      },
    );
  }

  Future<void> _searchUser(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _searchResult = null);
      return;
    }

    final result = await _profileRepository.getProfile(query.trim());
    if (!mounted) return;

    result.fold(
      onSuccess: (profile) {
        setState(() => _searchResult = _FriendUserData.fromProfile(profile));
      },
      onFailure: (_) {
        setState(() => _searchResult = null);
      },
    );
  }

  Future<void> _addFriend(_FriendUserData user) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null || _isFriend(user.id)) {
      return;
    }

    final result = await _profileRepository.sendFriendRequest(
      requesterUid: currentUserId,
      recipientUid: user.id,
    );

    if (!mounted) return;

    result.fold(
      onSuccess: (_) {
        setState(() {
          _friends.insert(0, user);
        });
      },
      onFailure: (_) {},
    );
  }

  Future<void> _removeFriend(String userId) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) {
      return;
    }

    final result = await _profileRepository.removeFriend(
      userUid: currentUserId,
      friendUid: userId,
    );
    if (!mounted) return;

    result.fold(
      onSuccess: (_) {
        setState(() {
          _friends.removeWhere((friend) => friend.id == userId);
        });
      },
      onFailure: (_) {},
    );
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
          isLoadingFriends: _isLoadingFriends,
          onSearchChanged: (value) {
            setState(() {});
            _searchUser(value);
          },
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

  factory _FriendUserData.fromProfile(Profile profile) {
    final palette = <Color>[
      FriendsUiConstants.avatarBlue,
      FriendsUiConstants.avatarYellow,
      FriendsUiConstants.avatarGreen,
      FriendsUiConstants.avatarOrange,
      FriendsUiConstants.avatarPurple,
    ];
    final hash = profile.uid.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
    return _FriendUserData(
      id: profile.uid,
      name: profile.name,
      city: profile.city ?? FriendsTexts.friendCityFallback,
      level: profile.trophies,
      avatarColor: palette[hash % palette.length],
    );
  }
}
