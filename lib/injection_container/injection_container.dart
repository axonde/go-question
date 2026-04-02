import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:go_question/core/network/network_info.dart';
import 'package:go_question/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:go_question/features/auth/data/source/datasource.dart';
import 'package:go_question/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:go_question/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth

  // Cubit
  sl.registerFactory(() => AuthCubit(sl()));

  // Repository
  sl.registerLazySingleton<IAuthRepository>(() => AuthRepositoryImpl(sl()));

  // Data sources
  sl.registerLazySingleton<IAuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  //! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External

  //FirebaseAuth
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  //InternetConnection
  sl.registerLazySingleton<InternetConnection>(() => InternetConnection());

  //! Config

  //AppRouter
}
