part of '../auth_screen.dart';

class _AuthHeader extends StatelessWidget {
  const _AuthHeader();

  @override
  Widget build(BuildContext context) {
    final isLogin =
        (context.findAncestorStateOfType<_AuthScreenState>()?._isLogin) ?? true;
    return Text(
      isLogin ? 'Го?' : 'Введите данные',
      style: Theme.of(context).textTheme.displayLarge,
      textAlign: TextAlign.center,
    );
  }
}
