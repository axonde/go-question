part of '../../pages/settings_page.dart';

class _SettingsToggleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggleTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SettingsUiConstants.tileBackground,
        borderRadius: BorderRadius.circular(UiConstants.borderRadius * 4),
        border: Border.all(color: SettingsUiConstants.tileBorder),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: UiConstants.horizontalPadding * 1.5,
          vertical: UiConstants.verticalPadding * 0.5,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: UiConstants.textSize * 0.86,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: UiConstants.textSize * 0.68,
            fontWeight: FontWeight.w600,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.secondary,
        activeTrackColor: AppColors.secondary.withValues(alpha: 0.35),
        inactiveThumbColor: AppColors.textSecondary,
        inactiveTrackColor: SettingsUiConstants.inactiveTrack,
      ),
    );
  }
}
