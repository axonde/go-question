import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_question/config/theme/ui_constants.dart';

class GqEditIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget svg = SvgPicture.asset('assets/icons/edit.svg');

    return Padding(padding: const EdgeInsets.all(UiConstants.gap), child: svg);
  }
}
