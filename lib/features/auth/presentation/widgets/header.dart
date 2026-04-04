part of '../pages/login_page.dart';

class _Header extends StatelessWidget {
  final bool isLogin;

  const _Header.login() : isLogin = true;
  const _Header.signin() : isLogin = false;

  @override
  Widget build(BuildContext context) {
    return Text(
      isLogin ? 'Го?' : 'Введите данные',
      style: Theme.of(context).textTheme.displayLarge,
      textAlign: TextAlign.center,
    );
  }
}
