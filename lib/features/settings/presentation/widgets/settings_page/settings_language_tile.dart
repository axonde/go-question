part of '../../pages/settings_page.dart';

class _SettingsLanguageTile extends StatelessWidget {
  final String? selectedLanguageCode;
  final ValueChanged<String?> onChanged;

  const _SettingsLanguageTile({
    required this.selectedLanguageCode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: SettingsUiConstants.tileBackground,
        borderRadius: BorderRadius.circular(UiConstants.borderRadius * 4),
        border: Border.all(color: SettingsUiConstants.tileBorder),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: UiConstants.horizontalPadding * 1.5,
        vertical: UiConstants.verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settingsLanguageTitle,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: UiConstants.textSize * 0.86,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: UiConstants.boxUnit * 0.5),
          Text(
            l10n.settingsLanguageSubtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: UiConstants.textSize * 0.68,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: UiConstants.boxUnit),
          DropdownButtonFormField<String>(
            initialValue: selectedLanguageCode,
            dropdownColor: SettingsUiConstants.tileBackground,
            iconEnabledColor: AppColors.textPrimary,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: UiConstants.textSize * 0.82,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: SettingsUiConstants.inactiveTrack,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(UiConstants.borderRadius),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: UiConstants.horizontalPadding,
                vertical: UiConstants.verticalPadding,
              ),
            ),
            items: [
              DropdownMenuItem(child: Text(l10n.settingsLanguageSystem)),
              DropdownMenuItem(
                value: LocalizationConstants.defaultLanguageCode,
                child: Text(l10n.settingsLanguageEnglish),
              ),
              DropdownMenuItem(
                value: LocalizationConstants.russianLanguageCode,
                child: Text(l10n.settingsLanguageRussian),
              ),
            ],
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
