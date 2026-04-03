import 'package:flutter/material.dart';
import 'package:go_question/features/friends/presentation/friends_screen.dart';
import 'package:go_question/features/home/presentation/home_screen.dart';
import 'package:go_question/features/settings/presentation/settings_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 1; // home in the middle

  static const _screens = [FriendsScreen(), HomeScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Друзья',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }
}
