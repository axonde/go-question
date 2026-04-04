import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/features/auth/presentation/cubit/auth_cubit.dart';

/// Кнопка выхода из аккаунта.
class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: OutlinedButton.icon(
        onPressed: () => context.read<AuthCubit>().signOut(),
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text(
          'Выйти из аккаунта',
          style: TextStyle(color: Colors.red),
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
