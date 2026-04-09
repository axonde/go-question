import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/app_text_styles.dart';
import 'package:go_question/core/constants/profile_messages.dart';

/// Loading state widget for profile initialization.
class ProfileInitializationLoadingWidget extends StatelessWidget {
  const ProfileInitializationLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 56,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 24),
            Text(
              profileInitializingMessage,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
