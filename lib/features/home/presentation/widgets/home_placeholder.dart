import 'package:flutter/material.dart';

/// Центральная заглушка главного экрана.
class HomePlaceholder extends StatelessWidget {
  const HomePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '[заглушка]',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
