import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/event_texts.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/core/widgets/buttons/gq_close_button.dart';
import 'package:go_question/core/widgets/text/clash_stroke_text.dart';
import 'package:go_question/features/events/domain/repositories/i_events_repository.dart';
import 'package:go_question/features/notifications/domain/entities/notification_entity.dart';
import 'package:go_question/features/notifications/domain/repositories/i_notifications_repository.dart';
import 'package:go_question/features/profile/constants/profile_presentation.dart';
import 'package:go_question/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:go_question/injection_container/injection_container.dart';

part 'notifications_sheet/notification_card.dart';
part 'notifications_sheet/notifications_list.dart';

class NotificationData {
  final String id;
  final NotificationType type;
  final bool isRead;
  final String title;
  final String body;
  final bool showAccept;
  final bool showReject;
  final String? userName;
  final String? userRegistrationId;
  final String? userRating;
  final String? userAge;
  final String? userGender;
  final String? userCity;
  final String? userBio;
  final int? userEventsAttended;
  final int? userEventsOrganized;
  final String? eventTitle;
  final String? eventDate;
  final String? eventLocation;
  final String? eventCategory;

  const NotificationData({
    required this.id,
    required this.type,
    required this.isRead,
    required this.title,
    required this.body,
    this.showAccept = false,
    this.showReject = false,
    this.userName,
    this.userRegistrationId,
    this.userRating,
    this.userAge,
    this.userGender,
    this.userCity,
    this.userBio,
    this.userEventsAttended,
    this.userEventsOrganized,
    this.eventTitle,
    this.eventDate,
    this.eventLocation,
    this.eventCategory,
  });

  factory NotificationData.fromEntity(NotificationEntity entity) {
    return NotificationData(
      id: entity.id,
      type: entity.type,
      isRead: entity.isRead,
      title: entity.title,
      body: entity.body,
      showAccept:
          (entity.type == NotificationType.joinRequest ||
              entity.type == NotificationType.friendRequest) &&
          !entity.isRead,
      showReject:
          (entity.type == NotificationType.joinRequest ||
              entity.type == NotificationType.friendRequest) &&
          !entity.isRead,
      userName: entity.requestUserName,
      userRegistrationId: entity.requestUserRegistrationId,
      userRating: entity.requestUserRating,
      userAge: entity.requestUserAge,
      userGender: entity.requestUserGender,
      userCity: entity.requestUserCity,
      userBio: entity.requestUserBio,
      userEventsAttended: entity.requestUserEventsAttended,
      userEventsOrganized: entity.requestUserEventsOrganized,
      eventTitle: entity.eventTitle,
      eventDate: entity.eventDate,
      eventLocation: entity.eventLocation,
      eventCategory: entity.eventCategory,
    );
  }
}

class NotificationsSheet extends StatefulWidget {
  const NotificationsSheet({super.key});

  @override
  State<NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<NotificationsSheet> {
  int? _expandedIndex;
  final Set<String> _processingIds = <String>{};

  Future<void> _acceptRequest(NotificationData data) async {
    final profile = context.read<ProfileBloc>().state.profile;
    if (profile == null || _processingIds.contains(data.id)) return;
    setState(() => _processingIds.add(data.id));
    try {
      if (data.type == NotificationType.friendRequest) {
        await sl<IProfileRepository>().acceptFriendRequest(data.id);
      } else {
        await sl<IEventsRepository>().approveJoinRequest(
          requestId: data.id,
          organizerId: profile.uid,
        );
      }
      await sl<INotificationsRepository>().markAsRead(data.id);
      if (!mounted) return;
      context.read<ProfileBloc>().add(ProfileRefreshRequested(profile.uid));
    } finally {
      if (mounted) {
        setState(() => _processingIds.remove(data.id));
      }
    }
  }

  Future<void> _rejectRequest(NotificationData data) async {
    final profile = context.read<ProfileBloc>().state.profile;
    if (profile == null || _processingIds.contains(data.id)) return;
    setState(() => _processingIds.add(data.id));
    try {
      if (data.type == NotificationType.friendRequest) {
        await sl<IProfileRepository>().declineFriendRequest(data.id);
      } else {
        await sl<IEventsRepository>().rejectJoinRequest(
          requestId: data.id,
          organizerId: profile.uid,
        );
      }
      await sl<INotificationsRepository>().markAsRead(data.id);
      if (!mounted) return;
      context.read<ProfileBloc>().add(ProfileRefreshRequested(profile.uid));
    } finally {
      if (mounted) {
        setState(() => _processingIds.remove(data.id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileBloc>().state.profile;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UiConstants.borderRadius * 8),
        ),
        border: Border(
          top: BorderSide(color: Color(0xFF62697B)),
          left: BorderSide(color: Color(0xFF62697B)),
          right: BorderSide(color: Color(0xFF62697B)),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xCC000000),
            offset: Offset(0, -UiConstants.shadowOffsetY),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: profile == null
                ? const Center(child: Text(EventTexts.notificationsEmptyState))
                : StreamBuilder<List<NotificationEntity>>(
                    stream: sl<INotificationsRepository>().watchNotifications(
                      profile.uid,
                    ),
                    builder: (context, snapshot) {
                      final notifications = (snapshot.data ?? const [])
                          .map(NotificationData.fromEntity)
                          .toList(growable: false);
                      if (snapshot.hasError && notifications.isEmpty) {
                        return const Center(
                          child: Text(EventTexts.notificationsEmptyState),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          notifications.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (notifications.isEmpty) {
                        return const Center(
                          child: Text(EventTexts.notificationsEmptyState),
                        );
                      }
                      return _NotificationsList(
                        notifications: notifications,
                        expandedIndex: _expandedIndex,
                        onToggle: (index) => setState(() {
                          _expandedIndex = _expandedIndex == index
                              ? null
                              : index;
                        }),
                        onAccept: _acceptRequest,
                        onReject: _rejectRequest,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF43C521), Color(0xFF3AB71D)],
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UiConstants.borderRadius * 8),
        ),
        boxShadow: [BoxShadow(color: Color(0xCC000000), offset: Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UiConstants.horizontalPadding * 2,
          vertical: UiConstants.verticalPadding * 1.5,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Center(
              child: _StrokeTitle(text: EventTexts.notificationsHeaderTitle),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GqCloseButton(onTap: () => Navigator.of(context).pop()),
            ),
          ],
        ),
      ),
    );
  }
}

class _StrokeTitle extends StatelessWidget {
  final String text;
  final double fontSize;
  final int maxLines;

  const _StrokeTitle({
    required this.text,
    this.fontSize = UiConstants.textSize * 1.5,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Clash',
            fontFamilyFallback: const ['Roboto', 'sans-serif'],
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = UiConstants.strokeWidth
              ..color = Colors.black,
          ),
        ),
        Text(
          text,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Clash',
            fontFamilyFallback: ['Roboto', 'sans-serif'],
            color: Colors.white,
            shadows: [Shadow(offset: Offset(0, UiConstants.textShadowOffsetY))],
          ).copyWith(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
