import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/core/widgets/text/clash_stroke_text.dart';

/// Данные уведомления для отображения.
class NotificationData {
  final String title;
  final String body;
  final bool showAccept;
  final bool showReject;

  const NotificationData({
    required this.title,
    required this.body,
    this.showAccept = false,
    this.showReject = false,
  });
}

/// Временные захардкоженные уведомления.
/// TODO: заменить на загрузку из репозитория.
const _kMockNotifications = [
  NotificationData(
    title: 'Запрос на участие',
    body:
        'Джиган хочет присоединиться к вашему ивенту: "Вечеринка на пляже", который состоится 04.04.2027 в 17:00.',
    showAccept: true,
    showReject: true,
  ),
  NotificationData(
    title: 'Событие скоро начнется!',
    body:
        'Событие "Вечеринка на пляже", которое состоится 04.04.2027 в 17:00, начнется через 2 часа. Не забудьте подготовиться!',
    showAccept: false,
    showReject: false,
  ),
];

/// Bottom sheet уведомлений (Clash Style).
class NotificationsSheet extends StatelessWidget {
  const NotificationsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: ListView.separated(
                padding: const EdgeInsets.all(UiConstants.horizontalPadding * 2),
                itemCount: _kMockNotifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final data = _kMockNotifications[index];
                  return NotificationCard(data: data);
                },
              ),
            ),
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
        color: Color(0xFF30D12D), // Зеленый фон заголовка
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
                  offset: Offset(0, 2),
                  blurRadius: 0,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: Center(
              child: SizedBox(
                width: 36,
                height: 36,
                child: GQButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icons.close,
                  baseColor: const Color(0xFFFF4B4B),
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

class NotificationCard extends StatelessWidget {
  final NotificationData data;

  const NotificationCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => NotificationDetailsSheet(data: data),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFDEE7F6),
          borderRadius: BorderRadius.circular(UiConstants.borderRadius * 2.5),
          border: Border.all(color: const Color(0xFF62697B), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12, right: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClashStrokeText(
              data.title,
              fontSize: 20,
              strokeWidth: 2.5,
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              data.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Russo One', // Применяем запрашиваемый шрифт
                fontFamilyFallback: ['Clash', 'Roboto', 'sans-serif'],
                color: Color(0xFF62697B),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Нажмите на уведомление, чтобы узнать детали.',
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Color(0xFF8A93A6),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (data.showAccept || data.showReject) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (data.showReject)
                    Transform.translate(
                      offset: const Offset(12, 0),
                      child: SizedBox(
                        width: 110,
                        height: 32,
                        child: GQButton(
                          baseColor: const Color(0xFFFF7175),
                          onPressed: () {},
                          text: 'Отклонить',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  if (data.showAccept)
                    SizedBox(
                      width: 110,
                      height: 32,
                      child: GQButton(
                        baseColor: const Color(0xFF76C274),
                        onPressed: () {},
                        text: 'Принять',
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet с подробностями (Clash Style).
class NotificationDetailsSheet extends StatelessWidget {
  final NotificationData data;

  const NotificationDetailsSheet({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Блок информации о пользователе (фейк плейсхолдер)
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E528E),
                          borderRadius: BorderRadius.circular(UiConstants.borderRadius * 4),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClashStrokeText('Джиган', fontSize: 24),
                            Text(
                              'Рейтинг: 158 🏆',
                              style: TextStyle(
                                fontFamily: 'Clash',
                                fontSize: 16,
                                color: Color(0xFF0E3457),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Полный текст
                  ClashStrokeText(
                    data.title,
                    fontSize: 22,
                    strokeWidth: 2.5,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEE7F6),
                      borderRadius: BorderRadius.circular(UiConstants.borderRadius * 2.5),
                      border: Border.all(
                        color: const Color(0xFF62697B),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      data.body,
                      style: const TextStyle(
                        fontFamily: 'Russo One',
                        fontFamilyFallback: ['Clash', 'Roboto', 'sans-serif'],
                        color: Color(0xFF0E3457),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Огромные кнопки снизу
                  if (data.showReject || data.showAccept)
                    Row(
                      children: [
                        if (data.showReject)
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: GQButton(
                                baseColor: const Color(0xFFFF7175),
                                onPressed: () {},
                                text: 'Отклонить',
                                fontSize: 16,
                              ),
                            ),
                          ),
                        if (data.showAccept && data.showReject) const SizedBox(width: 16),
                        if (data.showAccept)
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: GQButton(
                                baseColor: const Color(0xFF76C274),
                                onPressed: () {},
                                text: 'Принять',
                                fontSize: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
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
        color: Color(0xFF30D12D), // Зеленый фон
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(UiConstants.borderRadius * 6),
          topRight: Radius.circular(UiConstants.borderRadius * 6),
        ),
      ),
      child: Stack(
        children: [
          const Center(
            child: ClashStrokeText(
              'Подробнее',
              fontSize: 28,
              shadows: [
                Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 0,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: Center(
              child: SizedBox(
                width: 36,
                height: 36,
                child: GQButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icons.close,
                  baseColor: const Color(0xFFFF4B4B),
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
