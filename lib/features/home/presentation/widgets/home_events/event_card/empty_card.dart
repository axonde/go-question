part of '../../home_events.dart';

class _EmptyCard extends StatelessWidget {
  const _EmptyCard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: HomeUiConstants.panelBackground.withValues(alpha: 0.35),
        border: Border.fromBorderSide(
          BorderSide(color: AppColors.inputBorder.withValues(alpha: 0.3)),
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(UiConstants.borderRadius * 5),
        ),
        boxShadow: const [
          BoxShadow(
            color: HomeUiConstants.emptyCardShadow,
            offset: Offset(0, HomeUiConstants.cardShadowOffset),
          ),
        ],
      ),
    );
  }
}
