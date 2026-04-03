import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:go_question/features/auth/presentation/cubit/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showCitySelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const _CitySelectorSheet(),
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const _NotificationsSheet(),
    );
  }

  void _showBattleSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const _BattleSheet(),
    );
  }

  void _showModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const _ModeDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: city + notifications
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.location_city),
                    tooltip: 'Выбор города',
                    onPressed: () => _showCitySelector(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    tooltip: 'Уведомления',
                    onPressed: () => _showNotifications(context),
                  ),
                ],
              ),
            ),

            // Profile button — показывает данные авторизованного юзера
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final user =
                      state is AuthAuthenticated ? state.user : null;
                  return OutlinedButton.icon(
                    onPressed: () {}, // TODO: profile screen
                    icon: const Icon(Icons.account_circle_outlined),
                    label: Text(
                      user != null && user.name.isNotEmpty
                          ? user.name
                          : user?.email ?? 'Профиль',
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  );
                },
              ),
            ),

            // Center placeholder
            const Expanded(
              child: Center(
                child: Text(
                  '[заглушка]',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ),

            // Two action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _showBattleSheet(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Кнопка 1 (снизу)'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _showModeDialog(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Кнопка 2 (диалог)'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CitySelectorSheet extends StatelessWidget {
  const _CitySelectorSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Выбор города',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...['Москва', 'Санкт-Петербург', 'Казань'].map(
            (city) => ListTile(
              title: Text(city),
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsSheet extends StatelessWidget {
  const _NotificationsSheet();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Уведомления',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text('Нет новых уведомлений', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _BattleSheet extends StatelessWidget {
  const _BattleSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Кнопка 1 — bottom sheet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('[содержимое]', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}

class _ModeDialog extends StatelessWidget {
  const _ModeDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Кнопка 2 — диалог'),
      content: const Text('[содержимое диалога]'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Закрыть'),
        ),
      ],
    );
  }
}
