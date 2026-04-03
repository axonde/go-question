import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/auth_state.dart';

class EmailVerificationScreen extends StatelessWidget {
  final String email;
  const EmailVerificationScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      // Показываем hint (если есть) как SnackBar, не меняя экран
      listenWhen: (_, current) =>
          current is AuthAwaitingVerification && current.hint != null,
      listener: (context, state) {
        if (state is AuthAwaitingVerification && state.hint != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.hint!)),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.mark_email_unread_outlined,
                    size: 72, color: Colors.deepPurple),
                const SizedBox(height: 24),

                const Text(
                  'Подтвердите почту',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                Text(
                  'Мы отправили письмо на\n$email\n\nПерейдите по ссылке в письме, затем вернитесь сюда.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // Основная кнопка — проверить верификацию
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final loading = state is AuthLoading;
                    return ElevatedButton(
                      onPressed: loading
                          ? null
                          : () => context.read<AuthCubit>().checkEmailVerified(),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      child: loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Я подтвердил почту'),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Отправить письмо повторно
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final loading = state is AuthLoading;
                    return OutlinedButton.icon(
                      onPressed: loading
                          ? null
                          : () => context
                              .read<AuthCubit>()
                              .resendVerificationEmail(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      icon: const Icon(Icons.send_outlined),
                      label: const Text('Отправить письмо снова'),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Изменить почту — удаляет аккаунт и возвращает к регистрации
                TextButton(
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Изменить почту?'),
                        content: const Text(
                          'Текущий аккаунт будет удалён.\n'
                          'Вы сможете зарегистрироваться заново с правильным адресом.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Удалить и вернуться'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && context.mounted) {
                      context.read<AuthCubit>().cancelVerification();
                    }
                  },
                  child: const Text('Указал неверную почту? Изменить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
