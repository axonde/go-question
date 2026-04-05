import 'package:flutter/material.dart';

/// Bottom sheet выбора города.
class CitySelectorSheet extends StatelessWidget {
  const CitySelectorSheet({super.key});

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
