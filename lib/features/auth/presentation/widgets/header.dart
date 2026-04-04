import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final bool isLogin;

  const Header.login() : isLogin = true;
  const Header.signin() : isLogin = false;

  @override
  Widget build(BuildContext context) {
    return Text(
      isLogin ? 'Го?' : 'Введите данные',
      style: Theme.of(context).textTheme.displayLarge,
      textAlign: TextAlign.center,
    );
  }
}
