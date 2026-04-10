import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/router/router.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/app_text_styles.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/avatar_square.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/core/widgets/buttons/gq_close_button.dart';
import 'package:go_question/core/widgets/pressable.dart';
import 'package:go_question/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_question/features/home/presentation/widgets/city_selector_sheet.dart';
import 'package:go_question/features/profile/constants/profile_presentation.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:go_question/injection_container/injection_container.dart';
import 'package:image_picker/image_picker.dart';

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

    if (authUser == null) {
      return _GuestProfileDialog(
        onLoginTap: () {
          Navigator.of(context).pop();
          sl<AppRouter>().replace(const AuthFlowRoute());
        },
      );
    }

    if (profile == null) {
      return const DecoratedBox(
        decoration: BoxDecoration(color: AppColors.popupOutBackground),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final authNickname = authUser.nickname.trim();
    final profileName = profile.name.trim().isEmpty
        ? (profile.nickname.trim().isNotEmpty
              ? profile.nickname.trim()
              : (authNickname.isNotEmpty
                    ? authNickname
                    : ProfilePresentationConstants.displayNameFallback))
        : profile.name;
    final registrationId = profile.registrationId;
    final birthDate = profile.birthDate;
    final isBirthDatePlaceholder = birthDate == null;
    final birthDateText = isBirthDatePlaceholder
        ? 'Дата рождения не указана'
        : _formatBirthDate(birthDate);
    final cityValue = profile.city?.trim() ?? '';
    final isCityPlaceholder = cityValue.isEmpty;
    final city = isCityPlaceholder ? 'Город не указан' : cityValue;
    final isNamePlaceholder =
        profile.name.trim().isEmpty &&
        profile.nickname.trim().isEmpty &&
        authNickname.isEmpty;
    final imagePicker = ImagePicker();

    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.popupOutBackground),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        padding: MediaQuery.viewInsetsOf(context),
        child: Dialog(
          insetPadding: const EdgeInsets.all(UiConstants.boxUnit * 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UiConstants.borderRadius * 4),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 560,
              maxHeight: MediaQuery.sizeOf(context).height * 0.82,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: BoxBorder.all(
                  color: AppColors.lightStroke,
                  width: UiConstants.strokeWidth * 2,
                ),
                borderRadius: BorderRadius.circular(
                  UiConstants.borderRadius * 4,
                ),
                image: const DecorationImage(
                  image: AssetImage(
                    ProfilePresentationConstants.backgroundImagePath,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
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
                    _Avatar(
                      avatarUrl: profile.avatarUrl,
                      onTap: () async {
                        final picked = await imagePicker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 85,
                          maxWidth: 1024,
                        );
                        if (picked == null || !context.mounted) {
                          return;
                        }
                        final path = picked.path.trim();
                        if (path.isEmpty || !File(path).existsSync()) {
                          return;
                        }
                        context.read<ProfileBloc>().add(
                          ProfileUpdateRequested(
                            profile.copyWith(avatarUrl: path),
                          ),
                        );
                      },
                    ),
                    _Profile(
                      name: profileName,
                      registrationId: registrationId,
                      trophies: profile.trophies,
                    ),
                    _Characteristics(
                      birthDate: birthDateText,
                      isBirthDatePlaceholder: isBirthDatePlaceholder,
                      city: city,
                      isCityPlaceholder: isCityPlaceholder,
                      name: profileName,
                      isNamePlaceholder: isNamePlaceholder,
                      onNameChanged: (updatedName) {
                        context.read<ProfileBloc>().add(
                          ProfileUpdateRequested(
                            profile.copyWith(name: updatedName),
                          ),
                        );
                      },
                      onBirthDateChanged: (updatedBirthDate) {
                        final now = DateTime.now();
                        var age = now.year - updatedBirthDate.year;
                        final hadBirthdayThisYear =
                            now.month > updatedBirthDate.month ||
                            (now.month == updatedBirthDate.month &&
                                now.day >= updatedBirthDate.day);
                        if (!hadBirthdayThisYear) {
                          age -= 1;
                        }
                        context.read<ProfileBloc>().add(
                          ProfileUpdateRequested(
                            profile.copyWith(
                              birthDate: updatedBirthDate,
                              age: age < 0 ? 0 : age,
                            ),
                          ),
                        );
                      },
                      onCityChanged: (selectedCity) {
                        context.read<ProfileBloc>().add(
                          ProfileUpdateRequested(
                            profile.copyWith(city: selectedCity),
                          ),
                        );
                      },
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

class _GuestProfileDialog extends StatelessWidget {
  final VoidCallback onLoginTap;

  const _GuestProfileDialog({required this.onLoginTap});

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
              image: AssetImage(
                ProfilePresentationConstants.backgroundImagePath,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(UiConstants.boxUnit * 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GqCloseButton(onTap: () => Navigator.of(context).pop()),
                  ],
                ),
                const SizedBox(height: UiConstants.boxUnit * 2),
                const Text(
                  'Войти',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: UiConstants.textSize * 1.2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: UiConstants.boxUnit),
                const Text(
                  'Чтобы пользоваться друзьями, создавать ивенты и управлять участниками, нужно авторизоваться.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: UiConstants.textSize * 0.78,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: UiConstants.boxUnit * 2),
                SizedBox(
                  width: double.infinity,
                  child: GQButton(
                    onPressed: onLoginTap,
                    text: 'Войти',
                    baseColor: AppColors.primary,
                    widthFactor: 1,
                    height: UiConstants.boxUnit * 5.5,
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
