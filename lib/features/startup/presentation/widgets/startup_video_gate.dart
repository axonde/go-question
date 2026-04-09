import 'package:flutter/material.dart';
import 'package:go_question/core/constants/startup_constants.dart';
import 'package:go_question/core/services/background_music_service.dart';
import 'package:go_question/features/startup/presentation/pages/startup_video_page.dart';
import 'package:go_question/injection_container/injection_container.dart';

class StartupVideoGate extends StatefulWidget {
  final Widget child;

  const StartupVideoGate({super.key, required this.child});

  @override
  State<StartupVideoGate> createState() => _StartupVideoGateState();
}

class _StartupVideoGateState extends State<StartupVideoGate> {
  bool _startupCompleted = false;

  Future<void> _completeStartup() async {
    if (_startupCompleted) {
      return;
    }

    // Запускаем глобальную музыку
    await sl<BackgroundMusicService>().start(
      assetPath: StartupConstants.backgroundMusicAssetPath,
      volume: StartupConstants.backgroundMusicVolume,
      startTime: Duration(milliseconds: StartupConstants.backgroundMusicStartOffsetMs),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _startupCompleted = true;
    });
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
