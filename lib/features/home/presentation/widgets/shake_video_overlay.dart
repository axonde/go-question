import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ShakeVideoOverlay extends StatefulWidget {
  final VoidCallback onClose;
  final String videoAsset;

  const ShakeVideoOverlay({
    super.key,
    required this.onClose,
    required this.videoAsset,
  });

  @override
  State<ShakeVideoOverlay> createState() => _ShakeVideoOverlayState();
}

class _ShakeVideoOverlayState extends State<ShakeVideoOverlay> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  late double _closeButtonTop;
  late double _closeButtonLeft;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoAsset)
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
          _controller.play();
          _controller.setLooping(true);
        });
      });

    // Initial random position will be set in didChangeDependencies or build
    // because we need screen size.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setRandomPosition();
  }

  void _setRandomPosition() {
    final size = MediaQuery.of(context).size;
    final random = Random();
    // Keep the button within screen bounds (assuming button size is ~50x50)
    _closeButtonTop = random.nextDouble() * (size.height - 100) + 50;
    _closeButtonLeft = random.nextDouble() * (size.width - 100) + 50;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Container(
        color: Colors.black54,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Stack(
      children: [
        // Video Background
        Positioned.fill(
          child: Container(
            color: Colors.black,
            child: Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
        ),

        // Random Close Button
        Positioned(
          top: _closeButtonTop,
          left: _closeButtonLeft,
          child: IconButton(
            onPressed: widget.onClose,
            icon: const Icon(Icons.close, color: Colors.white, size: 40),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black45,
              shape: const CircleBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
