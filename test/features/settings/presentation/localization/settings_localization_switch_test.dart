import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/core/localization/presentation/app_localization_scope.dart';
import 'package:go_question/core/localization/presentation/app_strings.dart';
import 'package:go_question/core/localization/presentation/localization_context_extension.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/settings/domain/entities/app_settings.dart';
import 'package:go_question/features/settings/domain/errors/settings_failures.dart';
import 'package:go_question/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:go_question/features/settings/presentation/bloc/settings_bloc.dart';

class _FakeSettingsRepository implements ISettingsRepository {
  Result<AppSettings, SettingsFailure>? loadResult;
  AppSettings? lastSavedSettings;

  @override
  Future<Result<AppSettings, SettingsFailure>> loadSettings() async {
    return loadResult ?? const Success(AppSettings.defaults());
  }

  @override
  Future<Result<AppSettings, SettingsFailure>> saveSettings(
    AppSettings settings,
  ) async {
    lastSavedSettings = settings;
    return Success(settings);
  }
}

class _LocalizedTitleText extends StatelessWidget {
  const _LocalizedTitleText();

  @override
  Widget build(BuildContext context) {
    return Text(context.l10n.settingsPageTitle);
  }
}

void main() {
  testWidgets('changing language in SettingsBloc rebuilds localized UI', (
    tester,
  ) async {
    final repository = _FakeSettingsRepository()
      ..loadResult = const Success(AppSettings.defaults());
    final bloc = SettingsBloc(repository)..add(const SettingsRequested());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SettingsBloc>.value(
          value: bloc,
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              final code = AppStrings.resolveLanguageCode(
                selectedLanguageCode: state.settings.selectedLanguageCode,
                systemLocale: const Locale('en'),
              );

              return AppLocalizationScope(
                strings: AppStrings.fromLanguageCode(code),
                child: const Scaffold(body: _LocalizedTitleText()),
              );
            },
          ),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('Settings'), findsOneWidget);

    bloc.add(const SettingsLanguageChanged('ru'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));

    expect(find.text('Настройки'), findsOneWidget);
    expect(repository.lastSavedSettings?.selectedLanguageCode, 'ru');

    await bloc.close();
  });
}
