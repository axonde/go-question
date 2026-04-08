part of '../../home_events.dart';

const _cardDecoration = BoxDecoration(
  color: HomeUiConstants.panelBackground,
  border: Border.fromBorderSide(BorderSide(color: AppColors.inputBorder)),
  borderRadius: BorderRadius.all(Radius.circular(UiConstants.borderRadius * 5)),
  boxShadow: [
    BoxShadow(
      color: HomeUiConstants.panelShadow,
      offset: Offset(0, HomeUiConstants.cardShadowOffset),
    ),
  ],
);
