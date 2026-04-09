import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/core/constants/navigation_constants.dart';
import 'package:go_question/core/widgets/bottom_nav_bar.dart';
import 'package:go_question/features/friends/presentation/pages/friends_page.dart';
import 'package:go_question/features/home/presentation/pages/home_page.dart';
import 'package:go_question/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:go_question/features/settings/presentation/pages/settings_page.dart';
import 'package:go_question/injection_container/injection_container.dart';

@RoutePage(name: 'MainRoute')
class MainNavPage extends StatefulWidget {
  const MainNavPage({super.key});

  @override
  State<MainNavPage> createState() => _MainNavPageState();
}

class _MainNavPageState extends State<MainNavPage> {
  late final PageController _pageController = PageController(initialPage: 1);
  late final SettingsBloc _settingsBloc = sl<SettingsBloc>()
    ..add(const SettingsRequested());
  int _currentIndex = 1;

  void _onNavTap(int index) {
    if (_currentIndex == index) {
      return;
    }

    _pageController.animateToPage(
      index,
      duration: const Duration(
        milliseconds: NavigationConstants.pageAnimationDurationMs,
      ),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _settingsBloc.close();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>.value(
      value: _settingsBloc,
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final settings = state.settings;

          return Scaffold(
            body: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              children: [
                FriendsPage(
                  hintsEnabled: settings.hintsEnabled,
                  compactModeEnabled: settings.compactModeEnabled,
                ),
                HomePage(
                  notificationsEnabled: settings.notificationsEnabled,
                  hintsEnabled: settings.hintsEnabled,
                  compactModeEnabled: settings.compactModeEnabled,
                ),
                SettingsPage(
                  notificationsEnabled: settings.notificationsEnabled,
                  hintsEnabled: settings.hintsEnabled,
                  compactModeEnabled: settings.compactModeEnabled,
                  onNotificationsChanged: (value) {
                    context.read<SettingsBloc>().add(
                      SettingsNotificationsToggled(value),
                    );
                  },
                  onHintsChanged: (value) {
                    context.read<SettingsBloc>().add(
                      SettingsHintsToggled(value),
                    );
                  },
                  onCompactModeChanged: (value) {
                    context.read<SettingsBloc>().add(
                      SettingsCompactModeToggled(value),
                    );
                  },
                ),
              ],
            ),
            bottomNavigationBar: ClashNavBar(
              currentIndex: _currentIndex,
              onTap: _onNavTap,
            ),
          );
        },
      ),
    );
  }
}
