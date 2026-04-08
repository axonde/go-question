import 'package:flutter/material.dart';
import 'package:go_question/core/constants/home_texts.dart';

/// Bottom sheet уведомлений.
class NotificationsSheet extends StatelessWidget {
  const NotificationsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            HomeTexts.notificationsTitle,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            HomeTexts.notificationsEmpty,
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
