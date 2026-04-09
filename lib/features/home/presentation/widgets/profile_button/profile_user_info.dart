part of '../profile_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// _ProfileUserInfo — единственная ответственность: имя и никнейм пользователя.
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileUserInfo extends StatelessWidget {
  final String name;
  final String idLabel;
  final double slotHeight;

  const _ProfileUserInfo({
    required this.name,
    required this.idLabel,
    required this.slotHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GameText(
          text: name,
          fontSize: slotHeight * 0.27,
          fontWeight: FontWeight.bold,
        ),
        _GameText(text: idLabel, fontSize: slotHeight * 0.19),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _GameText — белый текст с чёрной обводкой в игровом стиле.
// Используется внутри библиотеки profile_button (parts имеют доступ).
// ─────────────────────────────────────────────────────────────────────────────

class _GameText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const _GameText({
    required this.text,
    required this.fontSize,
    this.fontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    const family = 'Clash';
    const fallback = ['Roboto', 'sans-serif'];

    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: family,
            fontFamilyFallback: fallback,
            fontSize: fontSize,
            fontWeight: fontWeight,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = UiConstants.strokeWidth
              ..color = Colors.black,
          ),
        ),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: family,
            fontFamilyFallback: fallback,
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
