import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_question/config/theme/app_colors.dart' show AppColors;
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/pressable.dart';

class GqCloseButton extends StatelessWidget {
  final VoidCallback onTap;

  const GqCloseButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Widget svg = SvgPicture.asset(
      'assets/icons/svgs/close.svg',
      semanticsLabel: 'Close',
    );

    return Pressable(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.stroke),
          borderRadius: BorderRadius.circular(UiConstants.borderRadius * 4),
          color: AppColors.redBackground,
        ),
        child: Padding(
          padding: const EdgeInsets.all(UiConstants.gap),
          child: svg,
        ),
      ),
    );
  }
}
