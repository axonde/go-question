import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:go_question/features/auth/presentation/cubit/auth_state.dart';

/// Кнопка профиля — отображает имя или email авторизованного пользователя.
class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final user = state is AuthAuthenticated ? state.user : null;
          return OutlinedButton.icon(
            onPressed: () {}, // TODO: profile page
            icon: const Icon(Icons.account_circle_outlined),
            label: Text(
              user != null && user.name.isNotEmpty
                  ? user.name
                  : user?.email ?? 'Профиль',
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
          );
        },
      ),
    );
  }
}
