import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/app_spacing.dart';
import 'package:go_question/config/theme/app_text_styles.dart';

class AppTheme {
  static ThemeData main() {
    final colorScheme = const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.surface,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: AppColors.textPrimary,
      onError: Colors.white,
    );

    return ThemeData(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      primaryColor: AppColors.primary,
      fontFamily: 'Clash',

      textTheme:
          const TextTheme(
            displayLarge: AppTextStyles.displayLarge,
            displayMedium: AppTextStyles.displayMedium,
            bodyLarge: AppTextStyles.bodyLarge,
            bodyMedium: AppTextStyles.bodyMedium,
            labelLarge: AppTextStyles.labelLarge,
          ).apply(
            bodyColor: AppColors.textPrimary,
            displayColor: AppColors.textPrimary,
          ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),

      // BottomAppBarTheme – новая замена bottomAppBarColor
      bottomAppBarTheme: const BottomAppBarTheme(
        color: AppColors.primaryVariant,
      ).data,

      // Кнопки
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: AppTextStyles.labelLarge,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),

      // input
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: AppColors.textSecondary),
        floatingLabelStyle: TextStyle(color: AppColors.textPrimary),
        filled: true,
        fillColor: AppColors.inputBackground,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF5EA3D3), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.2),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFE4450), width: 1.0),
        ),
      ),
    );
  }
}
