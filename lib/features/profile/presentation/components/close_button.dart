part of '../profile_screen.dart';

class CloseButton extends StatelessWidget {
  final VoidCallback onPressed;

  CloseButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 40, height: 40, child: Text('x'));
  }
}
