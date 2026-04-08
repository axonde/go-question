part of '../notifications_sheet.dart';

class NotificationDetailsSheet extends StatelessWidget {
  final NotificationData data;

  const NotificationDetailsSheet({
    super.key,
    required this.data,
  });

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
                          border: Border.all(color: AppColors.stroke),
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
                  'Подробнее',
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
