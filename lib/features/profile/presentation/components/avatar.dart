part of '../profile_screen.dart';

class _Avatar extends StatelessWidget {
  final String picturePath = 'assets/images/presets/default_ava.png';

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(picturePath),
        Positioned.fill(
          right: -15,
          child: Align(alignment: Alignment.centerRight, child: GqEditIcon()),
        ),
      ],
    );
  }
}
