import 'package:flutter/material.dart';

import '../widgets/battle_sheet.dart';
import '../widgets/city_selector_sheet.dart';
import '../widgets/home_action_buttons.dart';
import '../widgets/home_events.dart';
import '../widgets/home_placeholder.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/mode_dialog.dart';
import '../widgets/notifications_sheet.dart';
import '../widgets/profile_button.dart';

part 'home_page/home_layout_delegate.dart';

/// Главная страница приложения.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showCitySelector(BuildContext context) => showModalBottomSheet(
    context: context,
    builder: (_) => const CitySelectorSheet(),
  );

  void _showNotifications(BuildContext context) => showModalBottomSheet(
    context: context,
    builder: (_) => const NotificationsSheet(),
  );

  void _showBattleSheet(BuildContext context) => showModalBottomSheet(
    context: context,
    builder: (_) => const BattleSheet(),
  );

  void _showModeDialog(BuildContext context) =>
      showDialog(context: context, builder: (_) => const ModeDialog());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
            LayoutId(id: _HomeSlot.profile, child: const ProfileButton()),
            LayoutId(id: _HomeSlot.placeholder, child: const HomePlaceholder()),
            LayoutId(
              id: _HomeSlot.actions,
              child: HomeActionButtons(
                onBattleSheetTap: () => _showBattleSheet(context),
                onModeDialogTap: () => _showModeDialog(context),
              ),
            ),
            LayoutId(id: _HomeSlot.events, child: const HomeEvents()),
          ],
        ),
      ),
    );
  }
}
