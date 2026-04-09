import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_text_styles.dart';

class OnboardingSlidePage extends StatelessWidget {
  final String title;
  final String description;
  final Color backgroundColor;

  const OnboardingSlidePage({
    super.key,
    required this.title,
    required this.description,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Adaptive Illustration Placeholder
          Flexible(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(Icons.image, size: 80, color: Colors.white24),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles.displayMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28, // Slighly smaller for better fitting
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              description,
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
