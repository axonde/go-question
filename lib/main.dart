import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'package:go_question/core/network/network_info.dart';
import 'package:go_question/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:go_question/features/auth/data/source/datasource.dart';
import 'package:go_question/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:go_question/features/auth/presentation/cubit/auth_state.dart';
import 'package:go_question/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authDataSource = AuthRemoteDataSourceImpl(FirebaseAuth.instance);
  final authRepository = AuthRepositoryImpl(authDataSource);
  final networkInfo = NetworkInfoImpl(InternetConnection());

  runApp(MyApp(authRepository: authRepository, networkInfo: networkInfo));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final NetworkInfo networkInfo;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.networkInfo,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Question',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => AuthCubit(authRepository),
        child: Scaffold(
          body: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is AuthAuthenticated) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Привет, ${state.user.name}!'),
                      Text('ID: ${state.user.uid}'),
                      Text('Email: ${state.user.email}'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => context.read<AuthCubit>().signOut(),
                        child: const Text('Выйти'),
                      ),
                    ],
                  ),
                );
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => context.read<AuthCubit>().signUp(
                        'test@test.ru',
                        '123123',
                        'Иван Иванов',
                      ),
                      child: const Text('Зарегистрироваться (Тест)'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => context.read<AuthCubit>().signIn(
                        'test@test.ru',
                        '123123',
                      ),
                      child: const Text('Войти (Тест)'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
