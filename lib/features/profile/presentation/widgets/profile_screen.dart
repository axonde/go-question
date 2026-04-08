import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/app_text_styles.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/buttons/gq_close_button.dart';
import 'package:go_question/core/widgets/icons/gq_edit_icon.dart';
import 'package:go_question/core/widgets/pressable.dart';
import 'package:go_question/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_question/features/profile/constants/profile_presentation.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';

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
    final profile = context.watch<ProfileBloc>().state.profile;
    final authUser = context.watch<AuthBloc>().state.user;

    final profileName = profile?.name.trim();
    final displayName = (profileName == null || profileName.isEmpty)
        ? 'User'
        : profileName;

    final profileNickname = profile?.nickname.trim() ?? '';
    final authNickname = authUser?.nickname.trim() ?? '';
    final nickname = profileNickname.isNotEmpty
        ? profileNickname
        : (authNickname.isNotEmpty ? authNickname : 'user');

    final birthDate = profile?.birthDate;
    final isBirthDatePlaceholder = birthDate == null;
    final birthDateText = isBirthDatePlaceholder
        ? 'Дата рождения не указана'
        : _formatBirthDate(birthDate);
    final cityValue = profile?.city?.trim() ?? '';
    final isCityPlaceholder = cityValue.isEmpty;
    final city = isCityPlaceholder ? 'Город не указан' : cityValue;
    final isNamePlaceholder = profileName == null || profileName.isEmpty;

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
              image: AssetImage(
                ProfilePresentationConstants.backgroundImagePath,
              ),
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

                const _Avatar(),

                _Profile(nick: nickname),

                _Characteristics(
                  birthDate: birthDateText,
                  isBirthDatePlaceholder: isBirthDatePlaceholder,
                  city: city,
                  isCityPlaceholder: isCityPlaceholder,
                  name: displayName,
                  isNamePlaceholder: isNamePlaceholder,
                ),

                const SizedBox(height: 24),

                Text(
                  ProfilePresentationConstants.editHintText,
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

  String _formatBirthDate(DateTime birthDate) {
    final day = birthDate.day.toString().padLeft(2, '0');
    final month = birthDate.month.toString().padLeft(2, '0');
    final year = birthDate.year.toString();
    return '$day.$month.$year';
  }
}
