import 'package:flutter/material.dart';
import 'package:go_question/core/constants/event_texts.dart';
import 'package:go_question/core/constants/home_texts.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/presentation/pages/create_event_dialog.dart';
import 'package:go_question/features/events/presentation/pages/search_events_page.dart';
import 'package:go_question/features/profile/presentation/widgets/profile_screen.dart';

import '../widgets/city_selector_sheet.dart';
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

  void _showCitySelector(BuildContext context) => showModalBottomSheet(
    context: context,
    builder: (_) => const CitySelectorSheet(),
  );

  void _showNotifications(BuildContext context) {
    if (!notificationsEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(HomeTexts.notificationsDisabled)),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) => const NotificationsSheet(),
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

  void _showCreateEventDialog(BuildContext context) => showDialog<EventEntity>(
    context: context,
    barrierDismissible: false,
    builder: (_) => CreateEventDialog(
      onCreate: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(EventTexts.createSnackCreated)),
        );
      },
    ),
  );

  void _showProfileScreen(BuildContext context) =>
      showDialog(context: context, builder: (_) => const ProfileScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipRect(
        child: SafeArea(
          child: CustomMultiChildLayout(
            delegate: _HomeLayoutDelegate(),
            children: [
              LayoutId(
                id: _HomeSlot.topBar,
                child: HomeTopBar(
                  onAchievementsTap: () {}, // TODO: экран достижений
                  onCityTap: () => _showCitySelector(context),
                  onNotificationsTap: () => _showNotifications(context),
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
    );
  }
}
