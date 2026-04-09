import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:go_question/core/constants/navigation_constants.dart';
import 'package:go_question/core/constants/settings_constants.dart';
import 'package:go_question/core/services/background_music_service.dart';
import 'package:go_question/core/services/sfx_service.dart';
import 'package:go_question/core/widgets/bottom_nav_bar.dart';
import 'package:go_question/features/friends/presentation/pages/friends_page.dart';
import 'package:go_question/features/home/presentation/pages/home_page.dart';
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
  int _currentIndex = 1;
  bool _notificationsEnabled = SettingsConstants.defaultNotificationsEnabled;
  bool _hintsEnabled = SettingsConstants.defaultHintsEnabled;
  bool _compactModeEnabled = SettingsConstants.defaultCompactModeEnabled;
  bool _soundEnabled = SettingsConstants.defaultSoundEnabled;

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
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: [
          FriendsPage(
            hintsEnabled: _hintsEnabled,
            compactModeEnabled: _compactModeEnabled,
          ),
          HomePage(
            notificationsEnabled: _notificationsEnabled,
            hintsEnabled: _hintsEnabled,
            compactModeEnabled: _compactModeEnabled,
          ),
          SettingsPage(
            notificationsEnabled: _notificationsEnabled,
            hintsEnabled: _hintsEnabled,
            compactModeEnabled: _compactModeEnabled,
            soundEnabled: _soundEnabled,
            onNotificationsChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            onHintsChanged: (value) {
              setState(() {
                _hintsEnabled = value;
              });
            },
            onCompactModeChanged: (value) {
              setState(() {
                _compactModeEnabled = value;
              });
            },
            onSoundChanged: (value) async {
              setState(() {
                _soundEnabled = value;
              });
              await sl<SfxService>().setEnabled(value);
              await sl<BackgroundMusicService>().setVolume(value ? 1.0 : 0.0);
            },
          ),
        ],
      ),
      bottomNavigationBar: ClashNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
