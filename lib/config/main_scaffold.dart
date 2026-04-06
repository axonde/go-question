import 'package:flutter/material.dart';
import 'package:go_question/core/widgets/app_background.dart';
import 'package:go_question/core/widgets/bottom_nav_bar.dart';
import 'package:go_question/features/friends/presentation/pages/friends_page.dart';
import 'package:go_question/features/home/presentation/pages/home_page.dart';
import 'package:go_question/features/settings/presentation/pages/settings_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 1;

  static const _screens = [FriendsPage(), HomePage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: ClashNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}
