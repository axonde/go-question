part of '../bottom_nav_bar.dart';

class _NavBackground extends StatelessWidget {
  const _NavBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.07],
          colors: [Color(0xFF8492AA), Color(0xFF3C4758)],
        ),
        boxShadow: [BoxShadow(color: Color(0xCC000000), offset: Offset(0, -2))],
      ),
      child: SizedBox.expand(),
    );
  }
}
