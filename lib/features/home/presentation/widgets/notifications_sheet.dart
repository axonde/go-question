import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/core/widgets/buttons/gq_close_button.dart';
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
  ),
  NotificationData(
    title: 'Новое сообщение',
    body: 'У вас новое сообщение от организатора турнира.',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// NotificationsSheet — основная панель уведомлений.
// ─────────────────────────────────────────────────────────────────────────────

class NotificationsSheet extends StatelessWidget {
  const NotificationsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UiConstants.borderRadius * 8),
        ),
        border: Border(
          top: BorderSide(color: Color(0xFF62697B)),
          left: BorderSide(color: Color(0xFF62697B)),
          right: BorderSide(color: Color(0xFF62697B)),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xCC000000),
            offset: Offset(0, -UiConstants.shadowOffsetY),
          ),
        ],
      ),
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
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UiConstants.borderRadius * 8),
        ),
        boxShadow: [BoxShadow(color: Color(0xCC000000), offset: Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UiConstants.horizontalPadding * 2,
          vertical: UiConstants.verticalPadding * 1.5,
        ),
        child: Row(
          children: [
            const Spacer(),
            const Expanded(
              flex: 3,
              child: Center(
                child: ClashStrokeText(
                  'Уведомления',
                  fontSize: UiConstants.textSize * 1.5,
                  shadows: [
                    Shadow(offset: Offset(0, UiConstants.textShadowOffsetY)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: GqCloseButton(
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
