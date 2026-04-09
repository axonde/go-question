import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/router/router.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:go_question/injection_container/injection_container.dart';

@RoutePage()
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextSlide(BuildContext context) {
    if (_pageController.page != null && _pageController.page!.round() < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.read<OnboardingBloc>().add(
        const OnboardingCompletedRequested(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OnboardingBloc>()..add(const OnboardingStarted()),
      child: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state.status == OnboardingStatus.completed) {
            context.replaceRoute(const AuthFlowRoute());
          }
        },
        builder: (context, state) {
          if (state.status == OnboardingStatus.checking) {
            return const Scaffold(
              backgroundColor: Colors.black,
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: Colors.black,
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Блокируем свайп
              children: [
                _AnimatedOnboardingSlide(
                  key: const ValueKey(0),
                  bgAsset: 'assets/images/onboarding/bg.png',
                  characterAsset: 'assets/images/onboarding/princess.png',
                  bubbleText: 'Создавай\nмероприятия!',
                  tailDirection: BubbleTailDirection.leftEdge,
                  charLeft: -30,
                  charBottom: -10,
                  charHeight: 380,
                  bubbleLeft: 170,
                  bubbleBottom: 230,
                  tapTextRight: 24,
                  tapTextBottom: 24,
                  tapZoneRight: 0,
                  onTap: () => _nextSlide(context),
                ),
                _AnimatedOnboardingSlide(
                  key: const ValueKey(1),
                  bgAsset: 'assets/images/onboarding/bg2.png',
                  characterAsset: 'assets/images/onboarding/dragon.png',
                  bubbleText: 'Заводи новых\nдрузей!',
                  tailDirection: BubbleTailDirection.bottomRightEdge,
                  charRight: -30,
                  charBottom: -10,
                  charHeight: 360,
                  bubbleLeft: 50,
                  bubbleBottom: 290, // Выше дракона
                  tapTextLeft: 24,
                  tapTextBottom: 24,
                  tapZoneLeft: 0,
                  onTap: () => _nextSlide(context),
                ),
                _AnimatedOnboardingSlide(
                  key: const ValueKey(2),
                  bgAsset: 'assets/images/onboarding/bg3.png',
                  characterAsset: 'assets/images/onboarding/barbarian.png',
                  bubbleText: 'Присоединяйся\nи веселись!',
                  tailDirection: BubbleTailDirection.bottomLeftEdge,
                  charLeft: -20,
                  charBottom: -10,
                  charHeight: 390,
                  bubbleRight: 24,
                  bubbleBottom: 300, // Выше варвара
                  tapTextRight: 24,
                  tapTextBottom: 24,
                  tapZoneRight: 0,
                  onTap: () => _nextSlide(context),
                ),
                _FinalOnboardingSlide(
                  key: const ValueKey(3),
                  onAction: () {
                    context.read<OnboardingBloc>().add(
                      const OnboardingCompletedRequested(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


enum BubbleTailDirection { leftEdge, bottomRightEdge, bottomLeftEdge }

class _AnimatedOnboardingSlide extends StatefulWidget {
  final String bgAsset;
  final String characterAsset;
  final String bubbleText;
  final BubbleTailDirection tailDirection;
  
  final double? charLeft;
  final double? charRight;
  final double? charBottom;
  final double charHeight;
  
  final double? bubbleLeft;
  final double? bubbleRight;
  final double? bubbleBottom;
  
  final double? tapTextLeft;
  final double? tapTextRight;
  final double? tapTextBottom;
  
  final double? tapZoneLeft;
  final double? tapZoneRight;
  
  final VoidCallback onTap;

  const _AnimatedOnboardingSlide({
    super.key,
    required this.bgAsset,
    required this.characterAsset,
    required this.bubbleText,
    required this.tailDirection,
    this.charLeft,
    this.charRight,
    this.charBottom,
    required this.charHeight,
    this.bubbleLeft,
    this.bubbleRight,
    this.bubbleBottom,
    this.tapTextLeft,
    this.tapTextRight,
    this.tapTextBottom,
    this.tapZoneLeft,
    this.tapZoneRight,
    required this.onTap,
  });

  @override
  State<_AnimatedOnboardingSlide> createState() => _AnimatedOnboardingSlideState();
}

class _AnimatedOnboardingSlideState extends State<_AnimatedOnboardingSlide> {
  bool _showCharacter = false;
  bool _showBubble = false;
  bool _showSkip = false;

  @override
  void initState() {
    super.initState();
    _startAnimations();
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _showCharacter = true);
    });
    
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _showBubble = true);
    });
    
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _showSkip = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Фон
        Image.asset(
          widget.bgAsset,
          fit: BoxFit.cover,
        ),

        // Персонаж
        Positioned(
          left: widget.charLeft,
          right: widget.charRight,
          bottom: widget.charBottom,
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: _showCharacter ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              child: Image.asset(
                widget.characterAsset,
                height: widget.charHeight,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Облачко диалога
        Positioned(
          left: widget.bubbleLeft,
          right: widget.bubbleRight,
          bottom: widget.bubbleBottom,
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: _showBubble ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              child: _buildSpeechBubble(),
            ),
          ),
        ),

        // Текст "tap для далее"
        Positioned(
          left: widget.tapTextLeft,
          right: widget.tapTextRight,
          bottom: widget.tapTextBottom,
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: _showSkip ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              child: Text(
                'tap для далее',
                style: TextStyle(
                  fontFamily: 'Clash',
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ),

        // Невидимая зона тапа
        if (_showSkip)
          Positioned(
            top: 0,
            bottom: 0,
            left: widget.tapZoneLeft,
            right: widget.tapZoneRight,
            width: screenWidth * 0.5,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onTap,
            ),
          ),
      ],
    );
  }

  Widget _buildSpeechBubble() {
    return CustomPaint(
      painter: SpeechBubblePainter(tailDirection: widget.tailDirection),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        width: 172,
        child: Text(
          widget.bubbleText,
          style: const TextStyle(
            fontFamily: 'Clash',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            height: 1.1,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}

class SpeechBubblePainter extends CustomPainter {
  final BubbleTailDirection tailDirection;

  SpeechBubblePainter({required this.tailDirection});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(3),
    );

    final path = Path();
    if (tailDirection == BubbleTailDirection.leftEdge) {
      path
        ..moveTo(0, size.height - 30) // Выступ на левом краю
        ..lineTo(-12, size.height - 20)
        ..lineTo(0, size.height - 15)
        ..close();
    } else if (tailDirection == BubbleTailDirection.bottomLeftEdge) {
      path
        ..moveTo(30, size.height) // Выступ внизу слева
        ..lineTo(10, size.height + 15)
        ..lineTo(15, size.height)
        ..close();
    } else {
      path
        ..moveTo(size.width - 30, size.height) // Выступ внизу справа
        ..lineTo(size.width - 10, size.height + 15)
        ..lineTo(size.width - 15, size.height)
        ..close();
    }

    canvas.drawRRect(rrect, paint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SpeechBubblePainter oldDelegate) {
    return oldDelegate.tailDirection != tailDirection;
  }
}

class _FinalOnboardingSlide extends StatefulWidget {
  final VoidCallback onAction;

  const _FinalOnboardingSlide({super.key, required this.onAction});

  @override
  State<_FinalOnboardingSlide> createState() => _FinalOnboardingSlideState();
}

class _FinalOnboardingSlideState extends State<_FinalOnboardingSlide> {
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _showContent = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Фон
        Image.asset(
          'assets/images/onboarding/bg4.png',
          fit: BoxFit.cover,
        ),
        
        // Кнопки по центру
        AnimatedOpacity(
          opacity: _showContent ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 800),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Смещаем немного вниз, если "ГО?" на фоне занимает место сверху
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 60,
                    child: GQButton(
                      // Перекрашиваем в желтый
                      baseColor: const Color(0xFFFFC00F),
                      onPressed: widget.onAction,
                      text: 'да',
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 140,
                    height: 60,
                    child: GQButton(
                      // Перекрашиваем в синий
                      baseColor: const Color(0xFF2FA2FF),
                      onPressed: widget.onAction,
                      text: 'погнали!',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
