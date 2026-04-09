import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:go_question/config/router/router.dart';
import 'package:go_question/core/network/network_info.dart';
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
import 'package:go_question/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:go_question/features/profile/data/source/profile_remote_datasource.dart';
import 'package:go_question/features/profile/domain/errors/profile_exception_to_failure_mapper.dart';
import 'package:go_question/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:go_question/features/score/presentation/bloc/score_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

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

  //! Router

  sl.registerLazySingleton<AuthGuard>(() => const AuthGuard());
  sl.registerLazySingleton<GuestGuard>(() => GuestGuard(sl()));
  sl.registerLazySingleton<AppRouter>(
    () => AppRouter(authGuard: sl(), guestGuard: sl()),
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

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External

  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());
  sl.registerLazySingleton<InternetConnection>(() => InternetConnection());
}
