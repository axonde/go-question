part of '../notifications_sheet.dart';

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
                          color: AppColors.primaryVariant,
                          borderRadius: BorderRadius.circular(UiConstants.borderRadius * 4),
                          border: Border.all(color: AppColors.stroke, width: UiConstants.strokeWidth),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClashStrokeText(data.userName ?? 'User', fontSize: 24),
                            Text(
                              'Рейтинг: ${data.userRating ?? '0 🏆'}',
                              style: const TextStyle(
                                fontFamily: 'Clash',
                                fontSize: 16,
                                color: AppColors.primaryVariant,
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
                        color: AppColors.lightStroke,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      data.body,
                      style: const TextStyle(
                        fontFamily: 'Russo One',
                        fontFamilyFallback: ['Clash', 'Roboto', 'sans-serif'],
                        color: AppColors.primaryVariant,
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
                                baseColor: AppColors.error,
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
                                baseColor: AppColors.success,
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
        color: AppColors.notificationHeader,
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
