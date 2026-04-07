part of '../notifications_sheet.dart';

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
                fontFamily: 'Russo One',
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
