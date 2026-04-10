part of '../../pages/settings_page.dart';

class _SettingsPageContent extends StatelessWidget {
  final bool notificationsEnabled;
  final bool hintsEnabled;
  final bool compactModeEnabled;
  final bool soundEnabled;
  final String? selectedLanguageCode;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<bool> onHintsChanged;
  final ValueChanged<bool> onCompactModeChanged;
  final ValueChanged<bool> onSoundChanged;
  final ValueChanged<String?> onLanguageChanged;

  const _SettingsPageContent({
    required this.notificationsEnabled,
    required this.hintsEnabled,
    required this.compactModeEnabled,
    required this.soundEnabled,
    required this.selectedLanguageCode,
    required this.onNotificationsChanged,
    required this.onHintsChanged,
    required this.onCompactModeChanged,
    required this.onSoundChanged,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final verticalGap = compactModeEnabled
        ? UiConstants.boxUnit
        : UiConstants.boxUnit * 2;
    final pagePadding = compactModeEnabled
        ? UiConstants.horizontalPadding * 1.5
        : UiConstants.horizontalPadding * 2;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        pagePadding,
        compactModeEnabled
            ? UiConstants.topPadding * 1.5
            : UiConstants.topPadding * 2,
        pagePadding,
        compactModeEnabled
            ? UiConstants.bottomPadding * 1.5
            : UiConstants.bottomPadding * 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settingsPageTitle,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: UiConstants.textSize * 1.35,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: verticalGap),
          _SettingsSectionCard(
            title: l10n.settingsPreferencesTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hintsEnabled) ...[
                  Text(
                    l10n.settingsPreferencesHint,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: UiConstants.textSize * 0.76,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: verticalGap),
                ],
                _SettingsToggleTile(
                  title: l10n.settingsNotificationsTitle,
                  subtitle: l10n.settingsNotificationsSubtitle,
                  value: notificationsEnabled,
                  onChanged: onNotificationsChanged,
                ),
                SizedBox(
                  height: compactModeEnabled
                      ? UiConstants.boxUnit
                      : UiConstants.boxUnit * 1.5,
                ),
                _SettingsToggleTile(
                  title: l10n.settingsHintsTitle,
                  subtitle: l10n.settingsHintsSubtitle,
                  value: hintsEnabled,
                  onChanged: onHintsChanged,
                ),
                SizedBox(
                  height: compactModeEnabled
                      ? UiConstants.boxUnit
                      : UiConstants.boxUnit * 1.5,
                ),
                _SettingsToggleTile(
                  title: l10n.settingsSoundTitle,
                  subtitle: l10n.settingsSoundSubtitle,
                  value: soundEnabled,
                  onChanged: onSoundChanged,
                ),
                SizedBox(
                  height: compactModeEnabled
                      ? UiConstants.boxUnit
                      : UiConstants.boxUnit * 1.5,
                ),
                _SettingsToggleTile(
                  title: l10n.settingsCompactModeTitle,
                  subtitle: l10n.settingsCompactModeSubtitle,
                  value: compactModeEnabled,
                  onChanged: onCompactModeChanged,
                ),
                SizedBox(
                  height: compactModeEnabled
                      ? UiConstants.boxUnit
                      : UiConstants.boxUnit * 1.5,
                ),
                _SettingsLanguageTile(
                  selectedLanguageCode: selectedLanguageCode,
                  onChanged: onLanguageChanged,
                ),
              ],
            ),
          ),
          SizedBox(height: verticalGap),
          _SettingsSectionCard(
            title: l10n.settingsAccountTitle,
            child: const SignOutButton(),
          ),
        ],
      ),
    );
  }
}
