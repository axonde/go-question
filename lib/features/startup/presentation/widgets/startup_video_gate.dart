import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_question/core/constants/startup_constants.dart';
import 'package:go_question/features/startup/presentation/pages/startup_video_page.dart';

class StartupVideoGate extends StatefulWidget {
  final Widget child;

  const StartupVideoGate({super.key, required this.child});

  @override
  State<StartupVideoGate> createState() => _StartupVideoGateState();
}

class _StartupVideoGateState extends State<StartupVideoGate> {
  bool _startupCompleted = false;
  late final AudioPlayer _backgroundMusicPlayer = AudioPlayer();

  Future<void> _completeStartup() async {
    if (_startupCompleted) {
      return;
    }

    try {
      await _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundMusicPlayer.setVolume(
        StartupConstants.backgroundMusicVolume,
      );
      await _backgroundMusicPlayer.play(
        AssetSource(StartupConstants.backgroundMusicAssetPath),
      );
    } catch (_) {
      // Музыка стартует только когда ассет будет добавлен пользователем.
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _startupCompleted = true;
    });
  }

  @override
  void dispose() {
    _backgroundMusicPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        AnimatedSwitcher(
          duration: const Duration(
            milliseconds: StartupConstants.startupFadeDurationMs,
          ),
          child: _startupCompleted
              ? const SizedBox.shrink()
              : StartupVideoPage(
                  key: const ValueKey('startup-video-page'),
                  onComplete: _completeStartup,
                ),
        ),
      ],
    );
  }
}
