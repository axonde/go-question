part of '../../pages/startup_video_page.dart';

class _StartupVideoPlayerView extends StatelessWidget {
  final VideoPlayerController controller;

  const _StartupVideoPlayerView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
