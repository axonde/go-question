import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/router/router.dart';
import 'package:go_question/core/constants/event_texts.dart';
import 'package:go_question/core/constants/home_texts.dart';
import 'package:go_question/features/achievements/presentation/bloc/achievements_bloc.dart';
import 'package:go_question/features/achievements/presentation/widgets/achievements_dialog.dart';
import 'package:go_question/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/presentation/bloc/events_bloc.dart';
import 'package:go_question/features/events/presentation/pages/create_event_dialog.dart';
import 'package:go_question/features/events/presentation/pages/search_events_page.dart';
import 'package:go_question/features/home/presentation/widgets/city_selector_sheet.dart';
import 'package:go_question/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:go_question/features/leaderboard/presentation/pages/leaderboard_page.dart';
import 'package:go_question/features/profile/constants/profile_presentation.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:go_question/features/profile/presentation/widgets/profile_screen.dart';
import 'package:go_question/injection_container/injection_container.dart';

import '../widgets/home_action_buttons.dart';
import '../widgets/home_events.dart';
import '../widgets/home_placeholder.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/notifications_sheet.dart';
import '../widgets/profile_button.dart';

part 'home_page/home_layout_delegate.dart';

/// Главная страница приложения.
class HomePage extends StatelessWidget {
  final bool notificationsEnabled;
  final bool hintsEnabled;
  final bool compactModeEnabled;

  const HomePage({
    super.key,
    this.notificationsEnabled = true,
    this.hintsEnabled = true,
    this.compactModeEnabled = false,
  });

  Future<void> _showCitySelector(BuildContext context) async {
    final authUser = context.read<AuthBloc>().state.user;
    final profile = context.read<ProfileBloc>().state.profile;
    if (authUser == null || profile == null) {
      sl<AppRouter>().replace(const AuthFlowRoute());
      return;
    }

    final selectedCity = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CitySelectorSheet(selectedCity: profile.city),
    );

    if (selectedCity == null ||
        selectedCity.trim().isEmpty ||
        !context.mounted) {
      return;
    }

    context.read<ProfileBloc>().add(
      ProfileUpdateRequested(profile.copyWith(city: selectedCity.trim())),
    );
  }

  void _showNotifications(BuildContext context) {
    if (!notificationsEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(HomeTexts.notificationsDisabled)),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FractionallySizedBox(
        heightFactor: 0.9,
        child: NotificationsSheet(),
      ),
    );
  }

  Future<void> _showLeaderboard(BuildContext context) async {
    await showDialog<void>(
      context: context,
      useSafeArea: false,
      builder: (_) => const LeaderboardPage(),
    );
  }

  void _showSearchEvents(BuildContext context) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, _) => const SearchEventsSheet(),
    ),
  );

  Future<void> _showCreateEventDialog(BuildContext context) async {
    final authUser = context.read<AuthBloc>().state.user;
    if (authUser == null) {
      sl<AppRouter>().replace(const AuthFlowRoute());
      return;
    }

    final event = await showDialog<EventEntity>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CreateEventDialog(
        organizerAccountId: context.read<ProfileBloc>().state.profile?.uid,
      ),
    );

    if (event == null || !context.mounted) {
      return;
    }

    context.read<EventsBloc>().add(EventsCreateSubmitted(event));
    final currentProfile = context.read<ProfileBloc>().state.profile;
    if (currentProfile != null) {
      context.read<ProfileBloc>().add(
        EnsureProfileExistsRequested(
          uid: currentProfile.uid,
          initialEmail: currentProfile.email,
          initialName: currentProfile.name,
          initialNickname: currentProfile.nickname,
        ),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(EventTexts.createSnackCreated)),
    );
  }

  void _showProfileScreen(BuildContext context) {
    final authUser = context.read<AuthBloc>().state.user;
    if (authUser == null) {
      sl<AppRouter>().replace(const AuthFlowRoute());
      return;
    }

    showDialog(
      context: context,
      useSafeArea: false,
      builder: (_) => const ProfileScreen(),
    );
  }

  Future<void> _showAchievementsDialog(BuildContext context) async {
    final authUser = context.read<AuthBloc>().state.user;
    final profile = context.read<ProfileBloc>().state.profile;

    if (authUser == null || profile == null) {
      sl<AppRouter>().replace(const AuthFlowRoute());
      return;
    }

    context.read<AchievementsBloc>().add(
      AchievementsOpenedRequested(profile.uid),
    );

    await showDialog<void>(
      context: context,
      builder: (_) => const AchievementsDialog(),
    );

    if (!context.mounted) {
      return;
    }

    context.read<AchievementsBloc>().add(
      AchievementsViewedRequested(profile.uid),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileBloc>().state.profile;
    final notificationsState = context.watch<NotificationsBloc>().state;
    final hasUnreadAchievements =
        profile?.unseenAchievementIds.isNotEmpty == true;
    final hasUnreadNotifications = notificationsState.hasUnread;
    final trophies = profile?.trophies ?? 0;
    final currentCity = profile?.city?.trim().isNotEmpty == true
        ? profile!.city!.trim()
        : ProfilePresentationConstants.completionCityOptions.first;

    if (profile != null && notificationsState.activeUserId != profile.uid) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }

        context.read<NotificationsBloc>().add(
          NotificationsStarted(profile.uid),
        );
      });
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listenWhen: (previous, current) =>
              previous.profile?.uid != current.profile?.uid,
          listener: (context, state) {
            final uid = state.profile?.uid;
            if (uid == null || uid.trim().isEmpty) {
              return;
            }

            context.read<NotificationsBloc>().add(NotificationsStarted(uid));
          },
        ),
        BlocListener<NotificationsBloc, NotificationsState>(
          listenWhen: (previous, current) =>
              previous.popupNotification != current.popupNotification,
          listener: (context, state) {
            final popupNotification = state.popupNotification;
            if (popupNotification == null) {
              return;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${EventTexts.notificationsSnackNewPrefix} ${popupNotification.title}',
                ),
              ),
            );
            context.read<NotificationsBloc>().add(
              const NotificationsPopupConsumed(),
            );
          },
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ClipRect(
          child: SafeArea(
            child: CustomMultiChildLayout(
              delegate: _HomeLayoutDelegate(),
              children: [
                LayoutId(
                  id: _HomeSlot.topBar,
                  child: HomeTopBar(
                    onAchievementsTap: () => _showAchievementsDialog(context),
                    onCityTap: () => _showCitySelector(context),
                    onNotificationsTap: () => _showNotifications(context),
                    onLeaderboardTap: () => _showLeaderboard(context),
                    hasUnreadAchievements: hasUnreadAchievements,
                    hasUnreadNotifications: hasUnreadNotifications,
                    city: currentCity,
                  ),
                ),
                LayoutId(
                  id: _HomeSlot.profile,
                  child: ProfileButton(
                    onPressed: () => _showProfileScreen(context),
                  ),
                ),
                LayoutId(
                  id: _HomeSlot.placeholder,
                  child: HomePlaceholder(
                    hintsEnabled: hintsEnabled,
                    compactModeEnabled: compactModeEnabled,
                    trophies: trophies,
                  ),
                ),
                LayoutId(
                  id: _HomeSlot.actions,
                  child: HomeActionButtons(
                    onBattleSheetTap: () => _showSearchEvents(context),
                    onCreateEventTap: () => _showCreateEventDialog(context),
                  ),
                ),
                LayoutId(id: _HomeSlot.events, child: const HomeEvents()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
