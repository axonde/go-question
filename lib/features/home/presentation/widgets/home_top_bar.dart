import 'package:flutter/material.dart';

/// Верхняя панель главного экрана: выбор города и уведомления.
class HomeTopBar extends StatelessWidget {
  final VoidCallback onCityTap;
  final VoidCallback onNotificationsTap;

  const HomeTopBar({
    super.key,
    required this.onCityTap,
    required this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.location_city),
            tooltip: 'Выбор города',
            onPressed: onCityTap,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Уведомления',
            onPressed: onNotificationsTap,
          ),
        ],
      ),
    );
  }
}
