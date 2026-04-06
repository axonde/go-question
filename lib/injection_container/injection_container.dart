import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:go_question/core/network/network_info.dart';
import 'package:go_question/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:go_question/features/auth/data/source/datasource.dart';
import 'package:go_question/features/auth/domain/errors/auth_exception_to_failure_mapper.dart';
import 'package:go_question/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:go_question/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:go_question/features/score/presentation/cubit/score_cubit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth

  sl.registerFactory(() => AuthCubit(sl()));

  sl.registerLazySingleton<AuthExceptionToFailureMapper>(
    () => const AuthExceptionToFailureMapperImpl(),
  );

  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<IAuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl(), sl()),
  );

  sl.registerFactory(() => ScoreCubit());

  //! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External

  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());
  sl.registerLazySingleton<InternetConnection>(() => InternetConnection());
}
