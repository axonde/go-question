import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/event_texts.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/core/widgets/avatar_square.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/core/widgets/buttons/go_button/gq_close_button.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/presentation/bloc/events_bloc.dart';
import 'package:go_question/features/profile/constants/profile_presentation.dart';
import 'package:go_question/features/profile/domain/entities/profile.dart';
import 'package:go_question/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:go_question/injection_container/injection_container.dart';

class EventParticipantsDialog extends StatelessWidget {
  final EventEntity event;

  const EventParticipantsDialog({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final repository = sl<IProfileRepository>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(UiConstants.boxUnit * 2),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 720),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF10243D),
            borderRadius: BorderRadius.circular(UiConstants.borderRadius * 6),
            border: Border.all(color: const Color(0xFF5D7BA6)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x99000000),
                offset: Offset(0, UiConstants.shadowOffsetY),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(UiConstants.boxUnit * 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        EventTexts.buttonParticipants,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: EventTexts.fontClash,
                          fontFamilyFallback: EventTexts.fontFallback,
                          fontSize: UiConstants.textSize * 1.1,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GqCloseButton(onTap: () => Navigator.of(context).pop()),
                  ],
                ),
                const SizedBox(height: UiConstants.boxUnit * 1.5),
                Expanded(
                  child: FutureBuilder<_ParticipantsBundle>(
                    future: _loadParticipants(repository),
                    builder: (context, snapshot) {
                      final bundle = snapshot.data;
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          bundle == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (bundle == null) {
                        return const Center(
                          child: Text(
                            EventTexts.emptyEventsByFilters,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      return ListView(
                        children: [
                          _ParticipantsSection(
                            title: EventTexts.participantsRequestsSection,
                            users: bundle.pending,
                            emptyText: EventTexts.participantsEmptyRequests,
                            showApprove: true,
                            showReject: true,
                            showRemove: false,
                            onAccept: (profile) {
                              final organizerId = context
                                  .read<ProfileBloc>()
                                  .state
                                  .profile
                                  ?.uid;
                              if (organizerId == null) return;
                              context.read<EventsBloc>().add(
                                EventsJoinRequestApproved(
                                  requestId: '${profile.uid}_${event.id}',
                                  organizerId: organizerId,
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    EventTexts.snackBarParticipantApproved,
                                  ),
                                ),
                              );
                            },
                            onReject: (profile) {
                              final organizerId = context
                                  .read<ProfileBloc>()
                                  .state
                                  .profile
                                  ?.uid;
                              if (organizerId == null) return;
                              context.read<EventsBloc>().add(
                                EventsJoinRequestRejected(
                                  requestId: '${profile.uid}_${event.id}',
                                  organizerId: organizerId,
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    EventTexts.snackBarParticipantRejected,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: UiConstants.boxUnit * 1.5),
                          _ParticipantsSection(
                            title: EventTexts.participantsMembersSection,
                            users: bundle.approved,
                            emptyText: EventTexts.participantsEmptyMembers,
                            showApprove: false,
                            showReject: false,
                            showRemove: true,
                            onAccept: (_) {},
                            onReject: (profile) {
                              context.read<EventsBloc>().add(
                                EventsParticipantRemoveRequested(
                                  eventId: event.id,
                                  userId: profile.uid,
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    EventTexts.snackBarParticipantRemoved,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<_ParticipantsBundle> _loadParticipants(
    IProfileRepository repository,
  ) async {
    final ids = <String>{
      ...event.participantIds,
      ...event.pendingParticipantIds,
    }.toList();
    if (ids.isEmpty) {
      return const _ParticipantsBundle();
    }

    final result = await repository.getProfilesByIds(ids);
    return result.fold(
      onSuccess: (profiles) {
        final approved = <Profile>[];
        final pending = <Profile>[];
        for (final profile in profiles) {
          if (event.participantIds.contains(profile.uid)) {
            approved.add(profile);
          }
          if (event.pendingParticipantIds.contains(profile.uid)) {
            pending.add(profile);
          }
        }
        return _ParticipantsBundle(approved: approved, pending: pending);
      },
      onFailure: (_) => const _ParticipantsBundle(),
    );
  }
}

class _ParticipantsBundle {
  final List<Profile> approved;
  final List<Profile> pending;

  const _ParticipantsBundle({
    this.approved = const <Profile>[],
    this.pending = const <Profile>[],
  });
}

class _ParticipantsSection extends StatelessWidget {
  final String title;
  final List<Profile> users;
  final String emptyText;
  final bool showApprove;
  final bool showReject;
  final bool showRemove;
  final ValueChanged<Profile> onAccept;
  final ValueChanged<Profile> onReject;

  const _ParticipantsSection({
    required this.title,
    required this.users,
    required this.emptyText,
    required this.showApprove,
    required this.showReject,
    required this.showRemove,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: EventTexts.fontClash,
            fontFamilyFallback: EventTexts.fontFallback,
            fontSize: UiConstants.textSize * 0.9,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: UiConstants.boxUnit),
        if (users.isEmpty)
          Text(emptyText, style: const TextStyle(color: Color(0xFFB7C9E5)))
        else
          ...users.map(
            (profile) => Padding(
              padding: const EdgeInsets.only(bottom: UiConstants.boxUnit),
              child: _ParticipantTile(
                profile: profile,
                showApprove: showApprove,
                showReject: showReject,
                showRemove: showRemove,
                onAccept: () => onAccept(profile),
                onReject: () => onReject(profile),
              ),
            ),
          ),
      ],
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  final Profile profile;
  final bool showApprove;
  final bool showReject;
  final bool showRemove;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _ParticipantTile({
    required this.profile,
    required this.showApprove,
    required this.showReject,
    required this.showRemove,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<EventsBloc, bool>(
      (bloc) => bloc.state.isLoading,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF17365B),
        border: Border.all(color: const Color(0xFF5D7BA6)),
        borderRadius: BorderRadius.circular(UiConstants.borderRadius * 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            offset: Offset(0, UiConstants.shadowOffsetY * 0.7),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(UiConstants.boxUnit * 1.25),
        child: Row(
          children: [
            AvatarSquare(
              size: UiConstants.boxUnit * 4,
              imagePathOrUrl: profile.avatarUrl,
              borderRadius: UiConstants.borderRadius * 2.5,
              borderColor: Colors.white.withValues(alpha: 0.45),
              fallbackAssetPath: ProfilePresentationConstants.defaultAvatarPath,
              fallbackText: profile.name.isEmpty ? '?' : profile.name[0],
            ),
            const SizedBox(width: UiConstants.boxUnit),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'ID: ${profile.registrationId}',
                    style: const TextStyle(color: Color(0xFFB7C9E5)),
                  ),
                ],
              ),
            ),
            if (showApprove)
              GQButton(
                onPressed: onAccept,
                isLoading: isLoading,
                text: EventTexts.buttonApprove,
                baseColor: AppColors.secondary,
                width: UiConstants.boxUnit * 8,
                height: UiConstants.boxUnit * 4,
              ),
            if (showReject)
              Padding(
                padding: const EdgeInsets.only(left: UiConstants.boxUnit),
                child: GQButton(
                  onPressed: onReject,
                  isLoading: isLoading,
                  text: EventTexts.buttonReject,
                  baseColor: AppColors.primaryVariant,
                  width: UiConstants.boxUnit * 8,
                  height: UiConstants.boxUnit * 4,
                ),
              ),
            if (showRemove)
              Padding(
                padding: const EdgeInsets.only(left: UiConstants.boxUnit),
                child: GQButton(
                  onPressed: onReject,
                  isLoading: isLoading,
                  text: EventTexts.buttonRemove,
                  baseColor: AppColors.error,
                  width: UiConstants.boxUnit * 8,
                  height: UiConstants.boxUnit * 4,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
