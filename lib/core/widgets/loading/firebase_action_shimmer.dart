import 'package:flutter/material.dart';
import 'package:go_question/core/constants/loading_ui_constants.dart';

class FirebaseActionShimmer extends StatefulWidget {
  final bool isLoading;
  final Widget child;
  final double borderRadius;

  const FirebaseActionShimmer({
    super.key,
    required this.isLoading,
    required this.child,
    this.borderRadius = LoadingUiConstants.panelBorderRadius,
  });

  @override
  State<FirebaseActionShimmer> createState() => _FirebaseActionShimmerState();
}

class _FirebaseActionShimmerState extends State<FirebaseActionShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: LoadingUiConstants.shimmerDuration,
    );
    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant FirebaseActionShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading == oldWidget.isLoading) {
      return;
    }
    if (widget.isLoading) {
      _controller
        ..reset()
        ..repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AbsorbPointer(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Opacity(
              opacity: LoadingUiConstants.shimmerChildOpacity,
              child: widget.child,
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return ShaderMask(
                      blendMode: BlendMode.srcATop,
                      shaderCallback: (bounds) {
                        final safeWidth = bounds.width <= 0
                            ? 1.0
                            : bounds.width;
                        final slide =
                            (_controller.value * safeWidth * 2) - safeWidth;
                        return LinearGradient(
                          colors: const [
                            LoadingUiConstants.shimmerBase,
                            LoadingUiConstants.shimmerOverlay,
                            LoadingUiConstants.shimmerHighlight,
                            LoadingUiConstants.shimmerOverlay,
                            LoadingUiConstants.shimmerBase,
                          ],
                          stops: const [0, 0.35, 0.5, 0.65, 1],
                          transform: _SlidingGradientTransform(slide),
                        ).createShader(bounds);
                      },
                      child: Container(
                        color: LoadingUiConstants.shimmerOverlay.withValues(
                          alpha: LoadingUiConstants.shimmerOverlayOpacity,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(slidePercent, 0, 0);
  }
}
