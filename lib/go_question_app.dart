import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/core/theme/app_theme.dart';
import 'package:go_question/features/auth/presentation/cubit/auth_state.dart';

import 'package:go_question/features/auth/presentation/cubit/auth_cubit.dart';
import 'injection_container/injection_container.dart' as di;

class GoQuestionApp extends StatelessWidget {
  const GoQuestionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Question',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.main(),
      home: BlocProvider(
        create: (context) => di.sl<AuthCubit>(),
        child: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
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
    );
  }
}
