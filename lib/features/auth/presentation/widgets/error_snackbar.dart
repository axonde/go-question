part of '../pages/login_page.dart';

class _ErrorSnackBar extends StatelessWidget {
  final String message;

  const _ErrorSnackBar({required this.message});

  @override
  Widget build(BuildContext context) {
    return SnackBar(content: Text(message), backgroundColor: Colors.red);
  }
}
