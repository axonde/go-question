import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

/// Центральная заглушка главного экрана.
class HomePlaceholder extends StatelessWidget {
  final bool hintsEnabled;
  final bool compactModeEnabled;

  const HomePlaceholder({
    super.key,
    this.hintsEnabled = true,
    this.compactModeEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.84,
        heightFactor: 0.84,
        child: GifView.asset(
          'assets/images/background/arena.gif',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
