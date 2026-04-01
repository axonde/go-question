import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'firebase_options.dart';

import 'core/network/network_info.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Инициализируем системные зависимости (DI)
    final authRepository = AuthRepositoryImpl(FirebaseAuth.instance);
    final networkInfo = NetworkInfoImpl(InternetConnection());

    return MaterialApp(
      title: 'Go Question Backend',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        // 2. Создаем кубит и сразу проверяем кэш пользователя (Авто-логин)
        create: (context) => AuthCubit(authRepository, networkInfo)..checkAuthStatus(),
        child: Scaffold(
          body: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                // Покажет красный снекбар если пароль слабый или нет сети!
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error), backgroundColor: Colors.red),
                );
              } else if (state is AuthAuthenticated) {
                // Покажет зеленый если юзер прошел успешно
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('УСПЕХ! UID: ${state.userId} | Email: ${state.email}'), 
                    backgroundColor: Colors.green
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              return Center(
                child: ElevatedButton(
                  onPressed: () => context.read<AuthCubit>().signUp('test1@gmail.com', '12345678'),
                  child: const Text('Тест Регистрации'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
