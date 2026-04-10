import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

/// Центральная заглушка главного экрана.
class HomePlaceholder extends StatelessWidget {
  final bool hintsEnabled;
  final bool compactModeEnabled;
  final int trophies;

  const HomePlaceholder({
    super.key,
    this.hintsEnabled = true,
    this.compactModeEnabled = false,
    this.trophies = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.84,
        heightFactor: 0.84,
        child: trophies >= 5000
            ? Image.asset(
                'assets/images/background/legendary_arena.png',
                fit: BoxFit.contain,
              )
            : trophies >= 2500
            ? Image.asset(
                'assets/images/background/royal_arena.png',
                fit: BoxFit.contain,
              )
            : GifView.asset(
                'assets/images/background/arena.gif',
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
