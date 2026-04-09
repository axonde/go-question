import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';

class LoadingUiConstants {
  static const Duration shimmerDuration = Duration(milliseconds: 1200);
  static const double shimmerChildOpacity = 0.9;
  static const double shimmerOverlayOpacity = 0.26;
  static const double shimmerHighlightOpacity = 0.7;
  static const double buttonBorderRadius = UiConstants.borderRadius * 2;
  static const double panelBorderRadius = UiConstants.borderRadius * 5;

  static const Color shimmerBase = Color(0x00FFFFFF);
  static const Color shimmerOverlay = Color(0x42FFFFFF);
  static const Color shimmerHighlight = Color(0xB3FFFFFF);

  const LoadingUiConstants._();
}
