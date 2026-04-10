part of '../../pages/settings_page.dart';

class _SettingsPageContent extends StatelessWidget {
  final bool notificationsEnabled;
  final bool hintsEnabled;
  final bool compactModeEnabled;
  final bool soundEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<bool> onHintsChanged;
  final ValueChanged<bool> onCompactModeChanged;
  final ValueChanged<bool> onSoundChanged;

  const _SettingsPageContent({
    required this.notificationsEnabled,
    required this.hintsEnabled,
    required this.compactModeEnabled,
    required this.soundEnabled,
    required this.onNotificationsChanged,
    required this.onHintsChanged,
    required this.onCompactModeChanged,
    required this.onSoundChanged,
  });

  @override
  Widget build(BuildContext context) {
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
          const Text(
            SettingsTexts.pageTitle,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: UiConstants.textSize * 1.35,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: verticalGap),
          _SettingsSectionCard(
            title: SettingsTexts.preferencesTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hintsEnabled) ...[
                  const Text(
                    SettingsTexts.preferencesHint,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: UiConstants.textSize * 0.76,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: verticalGap),
                ],
                _SettingsToggleTile(
                  title: SettingsTexts.notificationsTitle,
                  subtitle: SettingsTexts.notificationsSubtitle,
                  value: notificationsEnabled,
                  onChanged: onNotificationsChanged,
                ),
                SizedBox(
                  height: compactModeEnabled
                      ? UiConstants.boxUnit
                      : UiConstants.boxUnit * 1.5,
                ),
                _SettingsToggleTile(
                  title: SettingsTexts.hintsTitle,
                  subtitle: SettingsTexts.hintsSubtitle,
                  value: hintsEnabled,
                  onChanged: onHintsChanged,
                ),
                SizedBox(
                  height: compactModeEnabled
                      ? UiConstants.boxUnit
                      : UiConstants.boxUnit * 1.5,
                ),
                _SettingsToggleTile(
                  title: SettingsTexts.soundTitle,
                  subtitle: SettingsTexts.soundSubtitle,
                  value: soundEnabled,
                  onChanged: onSoundChanged,
                ),
                SizedBox(
                  height: compactModeEnabled
                      ? UiConstants.boxUnit
                      : UiConstants.boxUnit * 1.5,
                ),
                _SettingsToggleTile(
                  title: SettingsTexts.compactModeTitle,
                  subtitle: SettingsTexts.compactModeSubtitle,
                  value: compactModeEnabled,
                  onChanged: onCompactModeChanged,
                ),
              ],
            ),
          ),
          SizedBox(height: verticalGap),
          const _SettingsSectionCard(
            title: SettingsTexts.accountTitle,
            child: SignOutButton(),
          ),
        ],
      ),
    );
  }
}
