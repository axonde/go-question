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
          decoration: const BoxDecoration(
            color: Color(0xFFDEE7F6),
            border: Border.fromBorderSide(BorderSide(color: Color(0xFF62697B))),
            borderRadius: BorderRadius.all(
              Radius.circular(UiConstants.borderRadius * 5),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x55000000),
                offset: Offset(0, UiConstants.shadowOffsetY),
              ),
            ],
          ),
          padding: const EdgeInsets.all(UiConstants.horizontalPadding * 1.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _StrokeTitle(
                text: data.title,
                fontSize: UiConstants.textSize * 1.05,
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              Text(
                data.body,
                maxLines: isExpanded ? null : 3,
                overflow: isExpanded ? null : TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'RussoOne',
                  fontFamilyFallback: ['Roboto', 'sans-serif'],
                  fontSize: UiConstants.textSize * 0.68,
                  color: Color(0xFF7187A8),
                  height: 1.35,
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
                    fontFamily: 'RussoOne',
                    color: Color(0xFF8A93A6),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
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
// _ExpandedContent — дополнительная информация о пользователе и событии.
// ─────────────────────────────────────────────────────────────────────────────

class _ExpandedContent extends StatelessWidget {
  final NotificationData data;
  const _ExpandedContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: UiConstants.boxUnit * 1.5),
        const Divider(height: 1, thickness: 0.5, color: Color(0xFF62697B)),
        const SizedBox(height: UiConstants.boxUnit * 1.25),
        // Информация о пользователе (если есть)
        if (data.userName != null) ...[
          _UserInfo(data: data),
          const SizedBox(height: UiConstants.boxUnit * 1.25),
          const Divider(height: 1, thickness: 0.5, color: Color(0xFF62697B)),
          const SizedBox(height: UiConstants.boxUnit * 1.25),
        ],
        // Детали события (если есть)
        if (data.eventTitle != null) _EventDetails(data: data),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _UserInfo — информация о пользователе.
// ─────────────────────────────────────────────────────────────────────────────

class _UserInfo extends StatelessWidget {
  final NotificationData data;
  const _UserInfo({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Аватар и основная информация
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: UiConstants.boxUnit * 6,
              height: UiConstants.boxUnit * 6,
              decoration: BoxDecoration(
                color: AppColors.primaryVariant,
                borderRadius: BorderRadius.circular(
                  UiConstants.borderRadius * 4,
                ),
                border: Border.all(color: AppColors.stroke),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: UiConstants.boxUnit * 4,
              ),
            ),
            const SizedBox(width: UiConstants.boxUnit * 1.5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClashStrokeText(
                    data.userName ?? 'User',
                    fontSize: UiConstants.textSize * 0.875,
                    strokeWidth: 2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Рейтинг: ${data.userRating ?? '0 🏆'}',
                    style: const TextStyle(
                      fontFamily: 'RussoOne',
                      fontSize: 14,
                      color: AppColors.primaryVariant,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: UiConstants.boxUnit * 1.5),
        // Детальная информация
        if (data.userAge != null ||
            data.userGender != null ||
            data.userCity != null)
          Container(
            padding: const EdgeInsets.all(UiConstants.boxUnit * 1.5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(UiConstants.borderRadius * 2),
              border: Border.all(color: const Color(0xFFB0BEC5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (data.userAge != null)
                  _UserDetailRow(
                    icon: Icons.cake_outlined,
                    label: data.userAge!,
                  ),
                if (data.userGender != null) ...[
                  const SizedBox(height: UiConstants.boxUnit * 0.75),
                  _UserDetailRow(
                    icon: Icons.person_outline,
                    label: data.userGender!,
                  ),
                ],
                if (data.userCity != null) ...[
                  const SizedBox(height: UiConstants.boxUnit * 0.75),
                  _UserDetailRow(
                    icon: Icons.location_city_outlined,
                    label: data.userCity!,
                  ),
                ],
                if (data.userEventsAttended != null ||
                    data.userEventsOrganized != null) ...[
                  const SizedBox(height: UiConstants.boxUnit),
                  const Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Color(0xFFB0BEC5),
                  ),
                  const SizedBox(height: UiConstants.boxUnit),
                  Row(
                    children: [
                      if (data.userEventsAttended != null)
                        Expanded(
                          child: _StatChip(
                            icon: Icons.event_available,
                            label: 'Посетил',
                            value: '${data.userEventsAttended}',
                          ),
                        ),
                      if (data.userEventsAttended != null &&
                          data.userEventsOrganized != null)
                        const SizedBox(width: UiConstants.boxUnit),
                      if (data.userEventsOrganized != null)
                        Expanded(
                          child: _StatChip(
                            icon: Icons.event_note,
                            label: 'Организовал',
                            value: '${data.userEventsOrganized}',
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        // Биография
        if (data.userBio != null) ...[
          const SizedBox(height: UiConstants.boxUnit * 1.25),
          const Text(
            'О себе:',
            style: TextStyle(
              fontFamily: 'RussoOne',
              fontSize: 14,
              color: Color(0xFF3A4560),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: UiConstants.boxUnit * 0.5),
          Text(
            data.userBio!,
            style: const TextStyle(
              fontFamily: 'RussoOne',
              fontSize: 13,
              color: Color(0xFF62697B),
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _UserDetailRow — строка с информацией о пользователе.
// ─────────────────────────────────────────────────────────────────────────────

class _UserDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _UserDetailRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: UiConstants.textSize * 0.9,
          color: const Color(0xFF546E7A),
        ),
        const SizedBox(width: UiConstants.boxUnit * 0.75),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'RussoOne',
              fontSize: 13,
              color: Color(0xFF3A4560),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StatChip — чип со статистикой пользователя.
// ─────────────────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UiConstants.boxUnit,
        vertical: UiConstants.boxUnit * 0.75,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(UiConstants.borderRadius * 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: UiConstants.textSize * 1.2,
            color: AppColors.primary,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'RussoOne',
              fontSize: 16,
              color: AppColors.primary,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'RussoOne',
              fontSize: 10,
              color: Color(0xFF546E7A),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _EventDetails — детальная информация о событии.
// ─────────────────────────────────────────────────────────────────────────────

class _EventDetails extends StatelessWidget {
  final NotificationData data;
  const _EventDetails({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (data.eventTitle != null)
          _DetailRow(icon: Icons.event, label: data.eventTitle!),
        if (data.eventDate != null) ...[
          const SizedBox(height: UiConstants.boxUnit * 0.75),
          _DetailRow(icon: Icons.access_time_outlined, label: data.eventDate!),
        ],
        if (data.eventLocation != null) ...[
          const SizedBox(height: UiConstants.boxUnit * 0.75),
          _DetailRow(
            icon: Icons.location_on_outlined,
            label: data.eventLocation!,
          ),
        ],
        if (data.eventCategory != null) ...[
          const SizedBox(height: UiConstants.boxUnit * 0.75),
          _DetailRow(icon: Icons.category_outlined, label: data.eventCategory!),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DetailRow — строка с иконкой и текстом.
// ─────────────────────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: UiConstants.textSize, color: const Color(0xFF3A4560)),
        const SizedBox(width: UiConstants.boxUnit),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'RussoOne',
              fontSize: UiConstants.textSize * 0.8,
              color: Color(0xFF3A4560),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
