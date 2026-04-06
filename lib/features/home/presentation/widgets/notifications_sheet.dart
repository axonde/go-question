import 'package:flutter/material.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/core/widgets/text/clash_stroke_text.dart';

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
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: const [
                  NotificationCard(
                    title: 'Запрос на участие',
                    body:
                        'Джиган хочет присоединиться к вашему ивенту: "Вечеринка на пляже", который состоится 04.04.2027 в 17:00.',
                    showAccept: true,
                    showReject: true,
                  ),
                  SizedBox(height: 12),
                  NotificationCard(
                    title: 'Событие скоро начнется!',
                    body:
                        'Событие "Вечеринка на пляже", которое состоится 04.04.2027 в 17:00, начнется через 2 часа. Не забудьте подготовиться!',
                    showAccept: true,
                    showReject: true,
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
        color: Color(0xFF30D12D), // Зеленый фон заголовка
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Stack(
        children: [
          const Center(child: ClashStrokeText('Уведомления', fontSize: 28)),
          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: Center(child: _buildCloseButton(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFFF0000), // Красный крестик
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(color: Colors.black45, offset: Offset(0, 3)),
          ],
        ),
        child: const Center(
          child: Icon(Icons.close, color: Colors.white, size: 22, weight: 800),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String body;
  final bool showAccept;
  final bool showReject;

  const NotificationCard({
    super.key,
    required this.title,
    required this.body,
    this.showAccept = false,
    this.showReject = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => NotificationDetailsSheet(
            title: title,
            body: body,
            showAccept: showAccept,
            showReject: showReject,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFDEE7F6),
          borderRadius: BorderRadius.circular(5),
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
              title,
              fontSize: 20,
              strokeWidth: 2.5,
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Roboto',
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
            const SizedBox(height: 12),
            if (showAccept || showReject)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (showReject)
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
                          textStrokeColor: Colors.black,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  if (showAccept)
                    SizedBox(
                      width: 110,
                      height: 32,
                      child: GQButton(
                        baseColor: const Color(0xFF76C274),
                        onPressed: () {},
                        text: 'Принять',
                        fontSize: 12,
                        textStrokeColor: Colors.black,
                        textColor: Colors.white,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet с подробностями (Clash Style).
class NotificationDetailsSheet extends StatelessWidget {
  final String title;
  final String body;
  final bool showAccept;
  final bool showReject;

  const NotificationDetailsSheet({
    super.key,
    required this.title,
    required this.body,
    this.showAccept = false,
    this.showReject = false,
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
                          borderRadius: BorderRadius.circular(8),
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
                    title,
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
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: const Color(0xFF62697B),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      body * 3, // Умножаем для примера длинного текста
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        color: Color(0xFF0E3457),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Огромные кнопки снизу
                  if (showReject || showAccept)
                    Row(
                      children: [
                        if (showReject)
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
                        if (showAccept && showReject) const SizedBox(width: 16),
                        if (showAccept)
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
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Stack(
        children: [
          const Center(child: ClashStrokeText('Подробнее', fontSize: 28)),
          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF0000),
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: const [
                      BoxShadow(color: Colors.black45, offset: Offset(0, 3)),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 22,
                      weight: 800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
