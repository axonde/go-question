import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/router/router.dart';
import 'package:go_question/config/theme/app_theme.dart';
import 'package:go_question/core/constants/profile_messages.dart';
import 'package:go_question/core/widgets/app_background.dart';
import 'package:go_question/features/achievements/presentation/bloc/achievements_bloc.dart';
import 'package:go_question/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_question/features/events/presentation/bloc/events_bloc.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';
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
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (context, state) {
            return MaterialApp.router(
              title: 'Go Question',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.main(),
              builder: (context, child) {
                return StartupVideoGate(
                  child: AppBackground(child: child ?? const SizedBox.shrink()),
                );
              },
              routerConfig: appRouter.config(),
            );
          },
        ),
      ),
    );
  }
}
