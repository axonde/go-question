part of '../notifications_sheet.dart';

class NotificationCard extends StatelessWidget {
  final NotificationData data;
  final bool isExpanded;
  final VoidCallback onToggle;

  const NotificationCard({
    super.key,
    required this.data,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFDEE7F6),
            borderRadius: BorderRadius.circular(UiConstants.borderRadius * 2.5),
            border: Border.all(color: AppColors.lightStroke),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          padding: const EdgeInsets.all(UiConstants.horizontalPadding * 1.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClashStrokeText(
                data.title,
                fontSize: 20,
                strokeWidth: 2.5,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                data.body,
                maxLines: isExpanded ? null : 2,
                overflow: isExpanded ? null : TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Russo One',
                  fontFamilyFallback: ['Clash', 'Roboto', 'sans-serif'],
                  color: Color(0xFF62697B),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              // Раскрывающийся контент
              AnimatedSize(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeInOutCubic,
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                child: isExpanded
                    ? _ExpandedContent(data: data)
                    : const SizedBox.shrink(),
              ),
              if (!isExpanded) ...[
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
              ],
              if (data.showAccept || data.showReject) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (data.showReject)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: SizedBox(
                          width: 110,
                          height: 32,
                          child: GQButton(
                            baseColor: AppColors.error,
                            onPressed: () {},
                            text: 'Отклонить',
                            fontSize: UiConstants.textSize * 0.75,
                          ),
                        ),
                      ),
                    if (data.showAccept)
                      SizedBox(
                        width: 110,
                        height: 32,
                        child: GQButton(
                          baseColor: AppColors.success,
                          onPressed: () {},
                          text: 'Принять',
                          fontSize: UiConstants.textSize * 0.75,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ExpandedContent — дополнительная информация о пользователе.
// ─────────────────────────────────────────────────────────────────────────────

class _ExpandedContent extends StatelessWidget {
  final NotificationData data;
  const _ExpandedContent({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.userName == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: UiConstants.boxUnit * 1.5),
        const Divider(height: 1, thickness: 0.5, color: Color(0xFF62697B)),
        const SizedBox(height: UiConstants.boxUnit * 1.25),
        Row(
          children: [
            Container(
              width: UiConstants.boxUnit * 5,
              height: UiConstants.boxUnit * 5,
              decoration: BoxDecoration(
                color: AppColors.primaryVariant,
                borderRadius:
                    BorderRadius.circular(UiConstants.borderRadius * 4),
                border: Border.all(
                  color: AppColors.stroke,
                ),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: UiConstants.boxUnit * 3,
              ),
            ),
            const SizedBox(width: UiConstants.boxUnit),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClashStrokeText(
                    data.userName ?? 'User',
                    fontSize: 18,
                    strokeWidth: 2,
                  ),
                  Text(
                    'Рейтинг: ${data.userRating ?? '0 🏆'}',
                    style: const TextStyle(
                      fontFamily: 'Clash',
                      fontSize: 14,
                      color: AppColors.primaryVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
