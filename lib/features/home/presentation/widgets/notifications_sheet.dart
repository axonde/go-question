import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/core/widgets/text/clash_stroke_text.dart';

part 'notifications_sheet/notification_card.dart';
part 'notifications_sheet/notifications_list.dart';
part 'notifications_sheet/notification_details_sheet.dart';

// ─────────────────────────────────────────────────────────────────────────────
// NotificationData — модель данных уведомления.
// ─────────────────────────────────────────────────────────────────────────────

class NotificationData {
  final String title;
  final String body;
  final bool showAccept;
  final bool showReject;
  final String? userName;
  final String? userRating;

  const NotificationData({
    required this.title,
    required this.body,
    this.showAccept = false,
    this.showReject = false,
    this.userName,
    this.userRating,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Временные захардкоженные уведомления.
// TODO: заменить на загрузку из Firestore.
// ─────────────────────────────────────────────────────────────────────────────

const _kMockNotifications = [
  NotificationData(
    title: 'Запрос на участие',
    body:
        'Джиган хочет присоединиться к вашему ивенту: "Вечеринка на пляже", который состоится 04.04.2027 в 17:00.',
    showAccept: true,
    showReject: true,
    userName: 'Джиган',
    userRating: '158 🏆',
  ),
  NotificationData(
    title: 'Событие скоро начнется!',
    body:
        'Событие "Вечеринка на пляже", которое состоится 04.04.2027 в 17:00, начнется через 2 часа. Не забудьте подготовиться!',
    showAccept: false,
    showReject: false,
  ),
  NotificationData(
    title: 'Новое сообщение',
    body: 'У вас новое сообщение от организатора турнира.',
    showAccept: false,
    showReject: false,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// NotificationsSheet — основная панель уведомлений.
// ─────────────────────────────────────────────────────────────────────────────

class NotificationsSheet extends StatelessWidget {
  const NotificationsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Column(
        children: [
          _buildHeader(context),
          const Expanded(
            child: _NotificationsList(notifications: _kMockNotifications),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: const BoxDecoration(
        color: AppColors.notificationHeader, // Из AppColors
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(UiConstants.borderRadius * 6),
          topRight: Radius.circular(UiConstants.borderRadius * 6),
        ),
      ),
      child: Stack(
        children: [
          const Center(
            child: ClashStrokeText(
              'Уведомления',
              fontSize: 28,
              shadows: [
                Shadow(
                  offset: Offset(0, UiConstants.shadowOffsetY),
                  blurRadius: 0,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Positioned(
            right: UiConstants.horizontalPadding * 1.5,
            top: 0,
            bottom: 0,
            child: Center(
              child: SizedBox(
                width: UiConstants.boxUnit * 4.5,
                height: UiConstants.boxUnit * 4.5,
                child: GQButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icons.close,
                  baseColor: AppColors.error,
                  iconSizeFactor: 0.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
