import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

/// Центральная заглушка главного экрана.
class HomePlaceholder extends StatelessWidget {
  final bool hintsEnabled;
  final bool compactModeEnabled;
  final bool isLegendaryArena;

  const HomePlaceholder({
    super.key,
    this.hintsEnabled = true,
    this.compactModeEnabled = false,
    this.isLegendaryArena = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.84,
        heightFactor: 0.84,
        child: isLegendaryArena
            ? Image.asset(
                'assets/images/background/legendary_arena.png',
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
