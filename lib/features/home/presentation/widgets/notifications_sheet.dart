import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/core/widgets/buttons/gq_close_button.dart';
import 'package:go_question/core/widgets/text/clash_stroke_text.dart';

part 'notifications_sheet/notification_card.dart';
part 'notifications_sheet/notifications_list.dart';

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
  final String? eventTitle;
  final String? eventDate;
  final String? eventLocation;
  final String? eventCategory;

  const NotificationData({
    required this.title,
    required this.body,
    this.showAccept = false,
    this.showReject = false,
    this.userName,
    this.userRating,
    this.eventTitle,
    this.eventDate,
    this.eventLocation,
    this.eventCategory,
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
    eventTitle: 'Вечеринка на пляже',
    eventDate: '04.04.2027 в 17:00',
    eventLocation: 'Пляж "Ласковый берег", Санкт-Петербург',
    eventCategory: 'Отдых и развлечения',
  ),
  NotificationData(
    title: 'Событие скоро начнется!',
    body:
        'Событие "Вечеринка на пляже", которое состоится 04.04.2027 в 17:00, начнется через 2 часа. Не забудьте подготовиться!',
    eventTitle: 'Вечеринка на пляже',
    eventDate: '04.04.2027 в 17:00',
    eventLocation: 'Пляж "Ласковый берег", Санкт-Петербург',
    eventCategory: 'Отдых и развлечения',
  ),
  NotificationData(
    title: 'Новое сообщение',
    body: 'У вас новое сообщение от организатора турнира.',
    userName: 'Организатор Иван',
    userRating: '245 🏆',
    eventTitle: 'Турнир по настольному теннису',
    eventDate: '15.04.2027 в 10:00',
    eventLocation: 'Спортивный комплекс "Олимп"',
    eventCategory: 'Спорт',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// NotificationsSheet — основная панель уведомлений.
// ─────────────────────────────────────────────────────────────────────────────

class NotificationsSheet extends StatefulWidget {
  const NotificationsSheet({super.key});

  @override
  State<NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<NotificationsSheet> {
  int? _expandedIndex;

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
          Expanded(
            child: _NotificationsList(
              notifications: _kMockNotifications,
              expandedIndex: _expandedIndex,
              onToggle: (index) => setState(() {
                _expandedIndex = _expandedIndex == index ? null : index;
              }),
            ),
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Center(
              child: ClashStrokeText(
                'Уведомления',
                fontSize: UiConstants.textSize * 1.5,
                shadows: [
                  Shadow(offset: Offset(0, UiConstants.textShadowOffsetY)),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GqCloseButton(
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
