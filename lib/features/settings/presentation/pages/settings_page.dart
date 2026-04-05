import 'package:flutter/material.dart';
import '../widgets/sign_out_button.dart';

/// Страница настроек.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Настройки\n[заглушка]',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ),
            SignOutButton(),
          ],
        ),
      ),
    );
  }
}
