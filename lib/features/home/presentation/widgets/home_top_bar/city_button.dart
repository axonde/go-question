part of '../home_top_bar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// _CityButton — кнопка выбора города.
// Текст автоматически уменьшается если не помещается (FittedBox.scaleDown).
// ─────────────────────────────────────────────────────────────────────────────

class _CityButton extends StatelessWidget {
  final String city;
  final VoidCallback onTap;
  final double height;

  const _CityButton({
    required this.city,
    required this.onTap,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: _frameDecoration,
        padding: const EdgeInsets.symmetric(
          horizontal: UiConstants.leftPadding * 1.5,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: _TopBarText(text: city),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _TopBarText — белый текст с обводкой для элементов верхней панели.
// ─────────────────────────────────────────────────────────────────────────────

class _TopBarText extends StatelessWidget {
  final String text;

  const _TopBarText({required this.text});

  @override
  Widget build(BuildContext context) {
    const family = 'Clash';
    const fallback = ['Roboto', 'sans-serif'];
    const fontSize = UiConstants.textSize * 0.8;

    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          text,
          maxLines: 1,
          style: TextStyle(
            fontFamily: family,
            fontFamilyFallback: fallback,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = HomeUiConstants.topBarTextStrokeWidth
              ..color = AppColors.stroke,
          ),
        ),
        Text(
          text,
          maxLines: 1,
          style: const TextStyle(
            fontFamily: family,
            fontFamilyFallback: fallback,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
