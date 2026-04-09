import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/home_ui_constants.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/core/widgets/pressable.dart';

part 'home_top_bar/achievement_button.dart';
part 'home_top_bar/city_button.dart';
part 'home_top_bar/notifications_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Общий стиль рамки для элементов верхней панели.
// Тот же визуальный язык, что у ProfileButton.
// ─────────────────────────────────────────────────────────────────────────────

const _frameDecoration = BoxDecoration(
  color: HomeUiConstants.panelBackground,
  border: Border.fromBorderSide(BorderSide(color: AppColors.inputBorder)),
  borderRadius: BorderRadius.all(Radius.circular(UiConstants.borderRadius * 5)),
  boxShadow: [
    BoxShadow(
      color: HomeUiConstants.panelShadow,
      offset: Offset(0, HomeUiConstants.cardShadowOffset),
    ),
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// HomeTopBar — верхняя панель главного экрана.
//
// [showAchievements] — показывать ли кнопку достижений (по умолчанию true).
// [city] — название выбранного города.
// ─────────────────────────────────────────────────────────────────────────────

class HomeTopBar extends StatelessWidget {
  final VoidCallback onAchievementsTap;
  final VoidCallback onCityTap;
  final VoidCallback onNotificationsTap;
  final bool showAchievements;
  final bool hasUnreadAchievements;
  final String city;

  const HomeTopBar({
    super.key,
    required this.onAchievementsTap,
    required this.onCityTap,
    required this.onNotificationsTap,
    this.showAchievements = true,
    this.hasUnreadAchievements = false,
    this.city = 'Санкт-Петербург',
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final buttonH = constraints.maxHeight - UiConstants.verticalPadding * 2;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UiConstants.horizontalPadding * 2,
            vertical: UiConstants.verticalPadding,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: UiConstants.boxUnit,
            children: [
              Expanded(
                child: _AchievementButton(
                  onTap: onAchievementsTap,
                  visible: showAchievements,
                  hasUnreadAchievements: hasUnreadAchievements,
                  height: buttonH,
                ),
              ),
              Expanded(
                flex: 5,
                child: _CityButton(
                  city: city,
                  onTap: onCityTap,
                  height: buttonH,
                ),
              ),
              Expanded(
                flex: 5,
                child: _NotificationsButton(
                  onTap: onNotificationsTap,
                  height: buttonH,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
