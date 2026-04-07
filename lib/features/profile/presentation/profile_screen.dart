import 'package:flutter/material.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/app_text_styles.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/buttons/gq_close_button.dart';
import 'package:go_question/core/widgets/icons/gq_edit_icon.dart';
import 'package:go_question/core/widgets/pressable.dart';

part 'components/avatar.dart';
part 'components/characteristics.dart';
part 'components/profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileContent();
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.popupOutBackground),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiConstants.borderRadius * 4),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: BoxBorder.all(
              color: AppColors.lightStroke,
              width: UiConstants.strokeWidth * 2,
            ),
            borderRadius: BorderRadius.circular(UiConstants.borderRadius * 4),
            image: const DecorationImage(
              image: AssetImage('assets/images/background/background.webp'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: UiConstants.topPadding * 2,
              right: UiConstants.rightPadding * 2,
              bottom: UiConstants.bottomPadding * 2,
              left: UiConstants.leftPadding * 2,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GqCloseButton(onTap: () => Navigator.of(context).pop()),
                  ],
                ),

                _Avatar(),

                const _Profile(name: 'Maxim Maximka', nick: 'papeiko'),

                const _Characteristics(
                  yearsOld: '19 лет',
                  city: 'Санкт-Петербург',
                  mail: 'danil-kolbasenko@gmail.com',
                ),

                const SizedBox(height: 24),

                Text(
                  'Для редактирования нажмите на выбранное поле',
                  style: AppTextStyles.labelMedium.merge(
                    const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
