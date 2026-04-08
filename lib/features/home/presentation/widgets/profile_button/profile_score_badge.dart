part of '../profile_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// _ProfileScoreBadge — единственная ответственность: иконка кубка + бейдж с очками.
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileScoreBadge extends StatelessWidget {
  final int score;
  final double slotHeight;

  const _ProfileScoreBadge({required this.score, required this.slotHeight});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // TODO: заменить на кастомную иконку кубка
        Icon(
          Icons.emoji_events,
          color: const Color(0xFFFFD700),
          size: slotHeight * 0.65,
        ),
        SizedBox(width: slotHeight * 0.08),
        _ScoreBadge(score: score, slotHeight: slotHeight),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ScoreBadge — тёмное окошко с цифрой очков.
// Минимальная ширина = ~4 символа; расширяется автоматически.
// При score >= 99999 показывает «макс.».
// ─────────────────────────────────────────────────────────────────────────────

class _ScoreBadge extends StatelessWidget {
  final int score;
  final double slotHeight;

  static const _badgeBg = Color(0xFF0D1929);
  static const _scoreColor = Color(0xFFFFC00F);

  const _ScoreBadge({required this.score, required this.slotHeight});

  @override
  Widget build(BuildContext context) {
    final isMax = score >= ScoreCubit.maxScore;
    final label = isMax ? 'макс.' : score.toString();
    final fontSize = slotHeight * 0.32;

    return Container(
      // Минимальная ширина обеспечивает отображение 4 цифр без схлопывания.
      constraints: BoxConstraints(minWidth: fontSize * 2.6),
      padding: EdgeInsets.symmetric(
        horizontal: slotHeight * 0.18,
        vertical: slotHeight * 0.08,
      ),
      decoration: BoxDecoration(
        color: _badgeBg,
        borderRadius: BorderRadius.circular(slotHeight * 0.2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Clash',
              fontFamilyFallback: const ['Roboto', 'sans-serif'],
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = fontSize * 0.07
                ..color = Colors.black,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Clash',
              fontFamilyFallback: const ['Roboto', 'sans-serif'],
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: _scoreColor,
            ),
          ),
        ],
      ),
    );
  }
}
