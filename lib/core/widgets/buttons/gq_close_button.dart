import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_question/config/theme/app_colors.dart' show AppColors;
import 'package:go_question/config/theme/ui_constants.dart';

class GqCloseButton extends StatelessWidget {
  final VoidCallback onPressed;

  GqCloseButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final Widget svg = SvgPicture.asset(
      'assets/icons/close.svg',
      semanticsLabel: 'Dart Logo',
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.stroke,
          width: UiConstants.strokeWidth,
        ),
        borderRadius: BorderRadius.circular(UiConstants.borderRadius * 4),
        color: AppColors.redBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.all(UiConstants.gap),
        child: svg,
      ),
    );
  }
}
