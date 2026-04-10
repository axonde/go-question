import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/core/constants/navigation_constants.dart';
import 'package:go_question/core/constants/settings_constants.dart';
import 'package:go_question/core/services/background_music_service.dart';
import 'package:go_question/core/services/sfx_service.dart';
import 'package:go_question/core/widgets/bottom_nav_bar.dart';
import 'package:go_question/features/events/presentation/bloc/events_bloc.dart';
import 'package:go_question/features/friends/presentation/pages/friends_page.dart';
import 'package:go_question/features/home/presentation/pages/home_page.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:go_question/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:go_question/features/settings/presentation/pages/settings_page.dart';
import 'package:go_question/injection_container/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _soundEnabled = SettingsConstants.defaultSoundEnabled;
  Timer? _syncTimer;

  @override
  void initState() {
    super.initState();
    _restoreSoundSetting();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _startPeriodicSync();
    });
  }

  Future<void> _restoreSoundSetting() async {
    final prefs = sl<SharedPreferences>();
    final savedValue = prefs.getBool(SettingsConstants.soundEnabledPrefKey);
    final soundEnabled = savedValue ?? SettingsConstants.defaultSoundEnabled;

    await sl<SfxService>().setEnabled(soundEnabled);
    await sl<BackgroundMusicService>().setVolume(soundEnabled ? 1.0 : 0.0);

    if (!mounted || _soundEnabled == soundEnabled) {
      return;
    }
    setState(() {
      _soundEnabled = soundEnabled;
    });
  }

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

  void _startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(minutes: 2), (_) {
      if (!mounted) {
        return;
      }
      context.read<EventsBloc>().add(const EventsSearchRefreshed());
      final uid = context.read<ProfileBloc>().state.profile?.uid;
      if (uid != null && uid.trim().isNotEmpty) {
        context.read<ProfileBloc>().add(ProfileRefreshRequested(uid));
      }
    });
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
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
                  soundEnabled: _soundEnabled,
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
                  onSoundChanged: (value) async {
                    await sl<SharedPreferences>().setBool(
                      SettingsConstants.soundEnabledPrefKey,
                      value,
                    );
                    setState(() {
                      _soundEnabled = value;
                    });
                    await sl<SfxService>().setEnabled(value);
                    await sl<BackgroundMusicService>().setVolume(
                      value ? 1.0 : 0.0,
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
