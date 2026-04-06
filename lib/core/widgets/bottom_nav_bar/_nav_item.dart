part of '../bottom_nav_bar.dart';

const _kAnimDuration = Duration(milliseconds: 200);
const double _kOverflowY = 10.0;

class _NavItem extends StatelessWidget {
  final int index;
  final String label;
  final String assetPath;
  final IconData fallbackIcon;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final double bottomPad;
  final bool large;

  const _NavItem({
    required this.index,
    required this.label,
    required this.assetPath,
    required this.fallbackIcon,
    required this.currentIndex,
    required this.onTap,
    required this.bottomPad,
    this.large = false,
  });

  bool get _isActive => index == currentIndex;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: () => onTap(index),
      child: LayoutBuilder(
        builder: (_, constraints) {
          final fullH = constraints.maxHeight;
          final contentH = fullH - bottomPad;

          final labelH = contentH * 0.20;
          final labelFontSize = (contentH * 0.14).clamp(10.0, 16.0);
          final iconAreaH = contentH - labelH;
          final iconSize =
              iconAreaH *
              (_isActive ? (large ? 1.15 : 1.05) : (large ? 0.92 : 0.84));

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: AnimatedContainer(
                  duration: _kAnimDuration,
                  color: _isActive
                      ? const Color(0xFF5B7A9E).withValues(alpha: 0.35)
                      : Colors.transparent,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: contentH,
                child: AnimatedOpacity(
                  duration: _kAnimDuration,
                  opacity: _isActive ? 1.0 : 0.50,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: iconAreaH,
                        child: Center(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(
                              begin: 0,
                              end: _isActive ? -_kOverflowY : 0,
                            ),
                            duration: _kAnimDuration,
                            curve: Curves.easeOut,
                            builder: (context, dy, child) =>
                                Transform.translate(
                                  offset: Offset(0, dy),
                                  child: AnimatedContainer(
                                    duration: _kAnimDuration,
                                    curve: Curves.easeOut,
                                    width: iconSize,
                                    height: iconSize,
                                    child: Image.asset(
                                      assetPath,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                            fallbackIcon,
                                            size: iconSize,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: labelH,
                        child: Center(
                          child: Text(
                            label,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'Clash',
                              fontFamilyFallback: const [
                                'Roboto',
                                'sans-serif',
                              ],
                              fontSize: labelFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
