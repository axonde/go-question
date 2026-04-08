part of '../../pages/settings_page.dart';

class _SettingsSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingsSectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0E3457).withValues(alpha: 0.74),
        border: Border.all(color: const Color(0xFF5EA3D3)),
        borderRadius: BorderRadius.circular(UiConstants.borderRadius * 5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            offset: const Offset(0, UiConstants.shadowOffsetY),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(UiConstants.boxUnit * 1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: UiConstants.textSize * 0.95,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: UiConstants.boxUnit * 1.25),
            child,
          ],
        ),
      ),
    );
  }
}
