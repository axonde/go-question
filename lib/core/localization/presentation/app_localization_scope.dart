import 'package:flutter/widgets.dart';

import 'app_strings.dart';

class AppLocalizationScope extends InheritedWidget {
  final AppStrings strings;

  const AppLocalizationScope({
    required this.strings,
    required super.child,
    super.key,
  });

  static AppStrings of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppLocalizationScope>();
    if (scope == null) {
      return AppStrings.fromLanguageCode('en');
    }

    return scope.strings;
  }

  @override
  bool updateShouldNotify(AppLocalizationScope oldWidget) {
    return oldWidget.strings.languageCode != strings.languageCode;
  }
}
