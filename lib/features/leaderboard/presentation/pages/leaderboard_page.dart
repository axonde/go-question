import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/router/router.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/localization/presentation/localization_context_extension.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/core/widgets/avatar_square.dart';
import 'package:go_question/core/widgets/buttons/go_button/gq_close_button.dart';
import 'package:go_question/core/widgets/loading/firebase_action_shimmer.dart';
import 'package:go_question/core/widgets/pressable.dart';
import 'package:go_question/features/friends/presentation/utils/friend_relation_utils.dart';
import 'package:go_question/features/profile/constants/profile_presentation.dart';
import 'package:go_question/features/profile/domain/entities/profile.dart';
import 'package:go_question/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:go_question/injection_container/injection_container.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final IProfileRepository _profileRepository = sl<IProfileRepository>();
  final Set<String> _pendingRequestIds = <String>{};

  Future<void> _addFriend(Profile target) async {
    final currentProfile = context.read<ProfileBloc>().state.profile;
    final currentUserId = currentProfile?.uid;
    if (currentUserId == null || currentUserId.trim().isEmpty) {
      sl<AppRouter>().replace(const AuthFlowRoute());
      return;
    }
    if (_pendingRequestIds.contains(target.uid)) {
      return;
    }

    setState(() => _pendingRequestIds.add(target.uid));
    final result = await _profileRepository.sendFriendRequest(
      requesterUid: currentUserId,
      recipientUid: target.uid,
    );
    if (!mounted) {
      return;
    }
    setState(() => _pendingRequestIds.remove(target.uid));
    result.fold(
      onSuccess: (_) {
        context.read<ProfileBloc>().add(ProfileRefreshRequested(currentUserId));
      },
      onFailure: (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentProfile = context.watch<ProfileBloc>().state.profile;
    final currentUserId = currentProfile?.uid ?? '';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            ProfilePresentationConstants.backgroundImagePath,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(UiConstants.boxUnit * 2),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.l10n.leaderboardTitle,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: UiConstants.textSize * 1.3,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      GqCloseButton(onTap: () => Navigator.of(context).pop()),
                    ],
                  ),
                  const SizedBox(height: UiConstants.boxUnit * 1.5),
                  Expanded(
                    child: StreamBuilder<List<Profile>>(
                      stream: _profileRepository.watchTopProfilesByTrophies(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            (snapshot.data ?? const <Profile>[]).isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final players = (snapshot.data ?? const <Profile>[])
                            .where((profile) => profile.trophies > 0)
                            .toList(growable: false);
                        if (players.isEmpty) {
                          return Center(
                            child: Text(
                              context.l10n.leaderboardEmpty,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: UiConstants.textSize * 0.8,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: players.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: UiConstants.boxUnit),
                          itemBuilder: (context, index) {
                            final player = players[index];
                            final isCurrent = currentUserId == player.uid;
                            final actionLabel = FriendRelationUtils.actionLabel(
                              currentProfile: currentProfile,
                              currentUserId: currentUserId,
                              otherUid: player.uid,
                            );
                            final canAdd = FriendRelationUtils.canSendRequest(
                              currentProfile: currentProfile,
                              currentUserId: currentUserId,
                              otherUid: player.uid,
                            );
                            final isPending = _pendingRequestIds.contains(
                              player.uid,
                            );

                            return _LeaderboardCard(
                              rank: index + 1,
                              player: player,
                              isCurrentUser: isCurrent,
                              actionLabel: actionLabel,
                              canAddFriend: canAdd,
                              isPending: isPending,
                              onAddFriend: () => _addFriend(player),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  final int rank;
  final Profile player;
  final bool isCurrentUser;
  final String actionLabel;
  final bool canAddFriend;
  final bool isPending;
  final VoidCallback onAddFriend;

  const _LeaderboardCard({
    required this.rank,
    required this.player,
    required this.isCurrentUser,
    required this.actionLabel,
    required this.canAddFriend,
    required this.isPending,
    required this.onAddFriend,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.popupOutBackground.withValues(alpha: 0.78),
        border: Border.all(
          color: isCurrentUser ? AppColors.success : AppColors.inputBorder,
          width: isCurrentUser ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(UiConstants.borderRadius * 5),
        boxShadow: const [
          BoxShadow(color: Color(0x66000000), offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UiConstants.horizontalPadding * 1.5,
          vertical: UiConstants.verticalPadding * 1.5,
        ),
        child: Row(
          children: [
            SizedBox(
              width: UiConstants.boxUnit * 2.4,
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: UiConstants.textSize * 0.95,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            AvatarSquare(
              size: UiConstants.boxUnit * 7,
              imagePathOrUrl: player.avatarUrl,
              borderRadius: UiConstants.borderRadius * 3,
              borderColor: AppColors.lightStroke,
              fallbackAssetPath: ProfilePresentationConstants.defaultAvatarPath,
              fallbackText: player.name,
            ),
            const SizedBox(width: UiConstants.boxUnit * 1.25),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name.trim().isNotEmpty
                        ? player.name.trim()
                        : player.nickname,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: UiConstants.textSize * 0.92,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: UiConstants.boxUnit * 0.25),
                  Text(
                    'ID: ${player.registrationId}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: UiConstants.textSize * 0.68,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: UiConstants.boxUnit),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${player.trophies} 🏆',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: UiConstants.textSize * 0.78,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: UiConstants.boxUnit * 0.5),
                  if (canAddFriend)
                    FirebaseActionShimmer(
                      isLoading: isPending,
                      borderRadius: UiConstants.borderRadius * 2,
                      child: Pressable(
                        onTap: onAddFriend,
                        child: Container(
                          width: UiConstants.boxUnit * 3.2,
                          height: UiConstants.boxUnit * 3.2,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(
                              UiConstants.borderRadius * 2,
                            ),
                            border: Border.all(color: AppColors.stroke),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: UiConstants.boxUnit * 2,
                          ),
                        ),
                      ),
                    )
                  else
                    Text(
                      actionLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: UiConstants.textSize * 0.62,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
