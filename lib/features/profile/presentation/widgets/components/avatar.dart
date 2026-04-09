part of '../profile_screen.dart';

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(ProfilePresentationConstants.defaultAvatarPath),
        const Positioned.fill(
          right: -15,
          child: Align(alignment: Alignment.centerRight, child: GqEditIcon()),
        ),
      ],
    );
  }
}
