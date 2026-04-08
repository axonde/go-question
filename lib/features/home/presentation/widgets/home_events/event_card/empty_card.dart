part of '../../home_events.dart';

class _EmptyCard extends StatelessWidget {
  const _EmptyCard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0E3457).withValues(alpha: 0.35),
        border: Border.fromBorderSide(
          BorderSide(color: const Color(0xFF5EA3D3).withValues(alpha: 0.3)),
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(UiConstants.borderRadius * 5),
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x44000000), offset: Offset(0, 2)),
        ],
      ),
    );
  }
}
