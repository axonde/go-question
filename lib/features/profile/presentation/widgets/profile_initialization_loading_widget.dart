import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_text_styles.dart';
import 'package:go_question/core/constants/profile_messages.dart';

/// Loading state widget for profile initialization.
class ProfileInitializationLoadingWidget extends StatelessWidget {
  const ProfileInitializationLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 24),
          Text(
            profileInitializingMessage,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
