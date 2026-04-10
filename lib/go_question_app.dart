import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/router/router.dart';
import 'package:go_question/config/theme/app_theme.dart';
import 'package:go_question/config/theme/no_overscroll_scroll_behavior.dart';
import 'package:go_question/core/constants/profile_messages.dart';
import 'package:go_question/core/localization/presentation/app_localization_scope.dart';
import 'package:go_question/core/localization/presentation/app_strings.dart';
import 'package:go_question/core/widgets/app_background.dart';
import 'package:go_question/features/achievements/presentation/bloc/achievements_bloc.dart';
import 'package:go_question/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_question/features/events/presentation/bloc/events_bloc.dart';
import 'package:go_question/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:go_question/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:go_question/features/startup/presentation/widgets/startup_video_gate.dart';
import 'package:go_question/injection_container/injection_container.dart';

class GoQuestionApp extends StatelessWidget {
  const GoQuestionApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = sl<AppRouter>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(const AuthStarted()),
        ),
        BlocProvider<ProfileBloc>(create: (_) => sl<ProfileBloc>()),
        BlocProvider<AchievementsBloc>(create: (_) => sl<AchievementsBloc>()),
        BlocProvider<EventsBloc>(
          create: (_) => sl<EventsBloc>()..add(const EventsSearchStarted()),
        ),
        BlocProvider<NotificationsBloc>(create: (_) => sl<NotificationsBloc>()),
        BlocProvider<SettingsBloc>(
          create: (_) => sl<SettingsBloc>()..add(const SettingsRequested()),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            appRouter.replace(const MainRoute());
            return;
          }

          if (state.status == AuthStatus.awaitingProfile) {
            final user = state.user;
            if (user != null) {
              context.read<ProfileBloc>().add(
                EnsureProfileExistsRequested(
                  uid: user.uid,
                  initialEmail: user.email,
                  initialName: user.nickname.isEmpty
                      ? profileDefaultInitialName
                      : user.nickname,
                  initialNickname: user.nickname,
                ),
              );
            }

            appRouter.replace(const ProfileInitializationRoute());
            return;
          }

          if (state.status == AuthStatus.unauthenticated) {
            context.read<ProfileBloc>().add(
              const ProfileSessionClearedRequested(),
            );
            context.read<AchievementsBloc>().add(
              const AchievementsSessionClearedRequested(),
            );
            context.read<EventsBloc>().add(
              const EventsSessionClearedRequested(),
            );
            context.read<EventsBloc>().add(const EventsSearchStarted());
            appRouter.replace(const MainRoute());
            return;
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (context, state) {
            return BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, settingsState) {
                final languageCode = AppStrings.resolveLanguageCode(
                  selectedLanguageCode:
                      settingsState.settings.selectedLanguageCode,
                  systemLocale:
                      WidgetsBinding.instance.platformDispatcher.locale,
                );
                final strings = AppStrings.fromLanguageCode(languageCode);

                return AppLocalizationScope(
                  strings: strings,
                  child: MaterialApp.router(
                    title: strings.appTitle,
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.main(),
                    scrollBehavior: const NoOverscrollScrollBehavior(),
                    builder: (context, child) {
                      return StartupVideoGate(
                        child: AppBackground(
                          child: child ?? const SizedBox.shrink(),
                        ),
                      );
                    },
                    routerConfig: appRouter.config(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
