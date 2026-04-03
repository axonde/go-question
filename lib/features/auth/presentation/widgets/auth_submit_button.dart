import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

/// Кнопка «Войти» / «Зарегистрироваться» с индикатором загрузки.
class AuthSubmitButton extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onSubmit;

  const AuthSubmitButton({
    super.key,
    required this.isLogin,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final loading = state is AuthLoading;
        return ElevatedButton(
          onPressed: loading ? null : onSubmit,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
          ),
          child: loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isLogin ? 'Войти' : 'Зарегистрироваться'),
        );
      },
    );
  }
}
