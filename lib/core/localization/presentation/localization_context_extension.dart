import 'package:flutter/widgets.dart';

import 'app_localization_scope.dart';
import 'app_strings.dart';

extension LocalizationContextExtension on BuildContext {
  AppStrings get l10n => AppLocalizationScope.of(this);
}
