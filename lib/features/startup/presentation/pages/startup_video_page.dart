import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/startup_constants.dart';
import 'package:go_question/core/constants/startup_texts.dart';
import 'package:go_question/core/constants/startup_ui_constants.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:video_player/video_player.dart';

part '../widgets/startup_video_page/startup_video_placeholder.dart';
part '../widgets/startup_video_page/startup_video_player_view.dart';

class StartupVideoPage extends StatefulWidget {
  final Future<void> Function() onComplete;

  const StartupVideoPage({super.key, required this.onComplete});

  @override
  State<StartupVideoPage> createState() => _StartupVideoPageState();
}

class _StartupVideoPageState extends State<StartupVideoPage> {
  VideoPlayerController? _controller;
  bool _isReady = false;
  bool _hasError = false;
  bool _onCompleteCalled = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final controller = VideoPlayerController.asset(
      StartupConstants.startupVideoAssetPath,
    );

    try {
      await controller.initialize();
      await controller.setVolume(StartupConstants.startupVideoVolume);
      await controller.setLooping(false);
      await controller.play();
      controller.addListener(_handlePlaybackState);

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _isReady = true;
        _hasError = false;
      });
    } catch (_) {
      await controller.dispose();

      if (!mounted) {
        return;
      }

      setState(() {
        _hasError = true;
      });
    }
  }

  void _handlePlaybackState() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    final position = controller.value.position;
    final duration = controller.value.duration;

    if (duration > Duration.zero && position >= duration) {
      if (!_onCompleteCalled) {
        _onCompleteCalled = true;
        widget.onComplete();
      }
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_handlePlaybackState);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: StartupUiConstants.background,
      child: _isReady && _controller != null
          ? _StartupVideoPlayerView(controller: _controller!)
          : _hasError
          ? SafeArea(
              child: Center(
                child: _StartupVideoPlaceholder(onComplete: widget.onComplete),
              ),
            )
          : const SizedBox.expand(),
    );
  }
}
