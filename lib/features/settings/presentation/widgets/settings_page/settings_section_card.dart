part of '../../pages/settings_page.dart';

class _SettingsSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingsSectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: SettingsUiConstants.cardBackground.withValues(alpha: 0.74),
        border: Border.all(color: SettingsUiConstants.cardBorder),
        borderRadius: BorderRadius.circular(UiConstants.borderRadius * 5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: SettingsUiConstants.cardShadowAlpha,
            ),
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
