import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/settings_constants.dart';
import 'package:go_question/core/constants/settings_texts.dart';
import 'package:go_question/core/constants/settings_ui_constants.dart';

import '../widgets/sign_out_button.dart';

part '../widgets/settings_page/settings_page_content.dart';
part '../widgets/settings_page/settings_section_card.dart';
part '../widgets/settings_page/settings_toggle_tile.dart';

class SettingsPage extends StatelessWidget {
  final bool notificationsEnabled;
  final bool hintsEnabled;
  final bool compactModeEnabled;
  final bool soundEnabled;
  final ValueChanged<bool>? onNotificationsChanged;
  final ValueChanged<bool>? onHintsChanged;
  final ValueChanged<bool>? onCompactModeChanged;
  final ValueChanged<bool>? onSoundChanged;

  const SettingsPage({
    super.key,
    this.notificationsEnabled = SettingsConstants.defaultNotificationsEnabled,
    this.hintsEnabled = SettingsConstants.defaultHintsEnabled,
    this.compactModeEnabled = SettingsConstants.defaultCompactModeEnabled,
    this.soundEnabled = SettingsConstants.defaultSoundEnabled,
    this.onNotificationsChanged,
    this.onHintsChanged,
    this.onCompactModeChanged,
    this.onSoundChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: _SettingsPageContent(
          notificationsEnabled: notificationsEnabled,
          hintsEnabled: hintsEnabled,
          compactModeEnabled: compactModeEnabled,
          soundEnabled: soundEnabled,
          onNotificationsChanged: onNotificationsChanged ?? (_) {},
          onHintsChanged: onHintsChanged ?? (_) {},
          onCompactModeChanged: onCompactModeChanged ?? (_) {},
          onSoundChanged: onSoundChanged ?? (_) {},
        ),
      ),
    );
  }
}
