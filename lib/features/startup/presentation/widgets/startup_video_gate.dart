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

    // Сначала делаем переход, затем фоном запускаем музыку.
    // Переход не должен зависеть от успешности загрузки аудио.
    if (!mounted) return;

    setState(() {
      _startupCompleted = true;
    });

    // Fire-and-forget: ошибки музыки не блокируют UI
    sl<BackgroundMusicService>()
        .start(assetPath: StartupConstants.backgroundMusicAssetPath)
        .catchError((_) {});
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
