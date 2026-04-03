import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';

/// Кнопка «Указал неверную почту» — удаляет аккаунт и возвращает к регистрации.
class VerificationChangeEmailButton extends StatelessWidget {
  const VerificationChangeEmailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _confirmAndCancel(context),
      child: const Text('Указал неверную почту? Изменить'),
    );
  }

  Future<void> _confirmAndCancel(BuildContext context) async {
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
  }
}
