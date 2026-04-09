import 'package:flutter/material.dart';

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
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: hintsEnabled ? 1 : 0.3,
        child: FractionallySizedBox(
          widthFactor: 0.84,
          heightFactor: 0.84,
          child: Image.asset(
            'assets/images/background/arena.gif',
            fit: BoxFit.contain,
            gaplessPlayback: true,
            filterQuality: FilterQuality.low,
          ),
        ),
      ),
    );
  }
}
