import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:go_question/config/router/router.dart';
import 'package:go_question/core/network/network_info.dart';
import 'package:go_question/core/services/background_music_service.dart';
import 'package:go_question/core/services/sfx_service.dart';
import 'package:go_question/features/achievements/data/repositories/achievements_repository_impl.dart';
import 'package:go_question/features/achievements/data/source/achievements_remote_data_source.dart';
import 'package:go_question/features/achievements/domain/repositories/i_achievements_repository.dart';
import 'package:go_question/features/achievements/presentation/bloc/achievements_bloc.dart';
import 'package:go_question/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:go_question/features/auth/data/source/auth_page_memory.dart';
import 'package:go_question/features/auth/data/source/datasource.dart';
import 'package:go_question/features/auth/domain/errors/auth_exception_to_failure_mapper.dart';
import 'package:go_question/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:go_question/features/auth/domain/services/auth_page_memory.dart';
import 'package:go_question/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_question/features/events/data/repositories/events_repository_impl.dart';
import 'package:go_question/features/events/data/source/events_remote_data_source.dart';
import 'package:go_question/features/events/domain/repositories/i_events_repository.dart';
import 'package:go_question/features/events/presentation/bloc/events_bloc.dart';
import 'package:go_question/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:go_question/features/notifications/data/source/notifications_remote_data_source.dart';
import 'package:go_question/features/notifications/domain/repositories/i_notifications_repository.dart';
import 'package:go_question/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:go_question/features/onboarding/data/source/onboarding_local_data_source.dart';
import 'package:go_question/features/onboarding/domain/repositories/i_onboarding_repository.dart';
import 'package:go_question/features/onboarding/domain/usecases/check_onboarding_status.dart';
import 'package:go_question/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:go_question/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:go_question/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:go_question/features/profile/data/source/profile_remote_datasource.dart';
import 'package:go_question/features/profile/domain/errors/profile_exception_to_failure_mapper.dart';
import 'package:go_question/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:go_question/features/score/presentation/bloc/score_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  //! Features - Onboarding

  sl.registerFactory(() => OnboardingBloc(sl(), sl()));

  sl.registerLazySingleton(() => CheckOnboardingStatus(sl()));
  sl.registerLazySingleton(() => CompleteOnboarding(sl()));

  sl.registerLazySingleton<IOnboardingRepository>(
    () => OnboardingRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(sl()),
  );

  //! Features - Auth

  sl.registerFactory(() => AuthBloc(sl(), sl()));

  sl.registerLazySingleton<AuthExceptionToFailureMapper>(
    () => const AuthExceptionToFailureMapperImpl(),
  );

  sl.registerLazySingleton<AuthPageMemory>(
    () => SharedPrefsAuthPageMemory(sl()),
  );

  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(sl(), sl(), sl()),
  );

  sl.registerLazySingleton<IAuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl(), sl()),
  );

  //! Features - Profile

  sl.registerFactory(() => ProfileBloc(sl()));

  sl.registerLazySingleton<ProfileExceptionToFailureMapper>(
    () => const ProfileExceptionToFailureMapperImpl(),
  );

  sl.registerLazySingleton<IProfileRepository>(
    () => ProfileRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<IProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl(), sl()),
  );

  //! Features - Events

  sl.registerFactory(() => EventsBloc(sl()));
  sl.registerLazySingleton<IEventsRepository>(() => EventsRepositoryImpl(sl()));

  sl.registerLazySingleton<IEventsRemoteDataSource>(
    () => EventsRemoteDataSourceImpl(sl()),
  );

  //! Features - Achievements

  sl.registerFactory(() => AchievementsBloc(sl()));
  sl.registerLazySingleton<IAchievementsRepository>(
    () => AchievementsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<IAchievementsRemoteDataSource>(
    () => AchievementsRemoteDataSourceImpl(sl()),
  );

  //! Router

  sl.registerLazySingleton<AuthGuard>(() => AuthGuard(sl(), sl()));
  sl.registerLazySingleton<GuestGuard>(() => GuestGuard(sl(), sl()));
  sl.registerLazySingleton<OnboardingGuard>(() => OnboardingGuard(sl()));
  sl.registerLazySingleton<AppRouter>(
    () => AppRouter(authGuard: sl(), guestGuard: sl(), onboardingGuard: sl()),
  );

  //! Other features

  sl.registerFactory(() => ScoreBloc());

  //! Features - Notifications
  sl.registerLazySingleton<INotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<INotificationsRepository>(
    () => NotificationsRepositoryImpl(sl()),
  );

  //! Core
  sl.registerLazySingleton<SfxService>(() => SfxService());
  sl.registerLazySingleton<BackgroundMusicService>(
    () => BackgroundMusicService(AudioPlayer()),
  );
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External

  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());
  sl.registerLazySingleton<InternetConnection>(() => InternetConnection());
}
