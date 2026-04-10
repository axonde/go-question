import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/city_constants.dart';
import 'package:go_question/core/localization/presentation/localization_context_extension.dart';

/// Bottom sheet выбора города.
class CitySelectorSheet extends StatelessWidget {
  final String? selectedCity;

  const CitySelectorSheet({super.key, this.selectedCity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(UiConstants.boxUnit * 3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.homeCitySelectorTitle,
            style: const TextStyle(
              fontSize: UiConstants.textSize * 1.1,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: UiConstants.boxUnit * 2),
          ...CityConstants.cityOptions.map(
            (city) => ListTile(
              title: Text(
                city,
                style: TextStyle(
                  color: city == selectedCity
                      ? AppColors.primary
                      : AppColors.textPrimary,
                  fontWeight: city == selectedCity
                      ? FontWeight.w800
                      : FontWeight.w600,
                ),
              ),
              trailing: city == selectedCity
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () => Navigator.pop(context, city),
            ),
          ),
        ],
      ),
    );
  }
}
