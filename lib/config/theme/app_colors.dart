import 'package:flutter/material.dart';

class AppColors {
  /// Основной акцент бренда.
  /// Пример: `ElevatedButton(style: ... backgroundColor: AppColors.primary)`.
  static const Color primary = Color(0xFF33B4FF);

  /// Затемнённый вариант основного акцента.
  /// Пример: `Container(color: AppColors.primaryVariant)`.
  static const Color primaryVariant = Color(0xFF1C4C8A);

  /// Вторичный акцент (золотой).
  /// Пример: `Icon(Icons.star, color: AppColors.secondary)`.
  static const Color secondary = Color(0xFFFFC00F);

  /// Затемнённый вторичный акцент.
  /// Пример: `BorderSide(color: AppColors.secondaryVariant)`.
  static const Color secondaryVariant = Color(0xFFEC7E00);

  /// Фон экранов с кастомным градиентом/изображением.
  /// Пример: `Scaffold(backgroundColor: AppColors.background)`.
  static const Color popupOutBackground = Color(0x94000000);
  static const Color scaffoldBackgroundColor = Colors.transparent;
  static const Color redBackground = Color(0xFFC50006);

  /// Базовый цвет поверхностей карточек и панелей.
  /// Пример: `Card(color: AppColors.surface)`.
  static const Color surface = Color(0xFF07377F);

  /// Полупрозрачная подложка полей ввода.
  /// Пример: `InputDecoration(fillColor: AppColors.inputBackground)`.
  static const Color inputBackground = Color(0xF00E3457);

  /// Граница поля ввода в обычном состоянии.
  /// Пример: `OutlineInputBorder(borderSide: BorderSide(color: AppColors.inputBorder))`.
  static const Color inputBorder = Color(0xFF5EA3D3);

  /// Граница поля ввода в фокусе.
  /// Пример: `focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.inputFocused))`.
  static const Color inputFocused = Color(0xFF2196F3);

  /// Основной цвет текста на тёмных поверхностях.
  /// Пример: `TextStyle(color: AppColors.textPrimary)`.
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Вторичный цвет текста (плейсхолдеры/лейблы).
  /// Пример: `TextStyle(color: AppColors.textSecondary)`.
  static const Color textSecondary = Color(0xFFABAAAA);

  static const Color stroke = Color(0xFF202020);
  static const Color lightStroke = Color(0xFF576278);

  /// Цвет успешных состояний.
  /// Пример: `SnackBar(backgroundColor: AppColors.success)`.
  static const Color success = Color(0xFF09B103);

  /// Цвет ошибок и невалидных состояний.
  /// Пример: `ThemeData(colorScheme: ... copyWith(error: AppColors.error))`.
  static const Color error = Color(0xFFFE4450);
}
