import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/app_text_styles.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/buttons/gq_close_button.dart';
import 'package:go_question/core/widgets/icons/gq_edit_icon.dart';
import 'package:go_question/core/widgets/pressable.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:go_question/injection_container/injection_container.dart';

part 'components/avatar.dart';
part 'components/characteristics.dart';
part 'components/profile.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(ProfileLoadRequested(uid)),
      child: const _ProfileContent(),
    );
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
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GqCloseButton(
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),

                    _Avatar(),

                    if (state.isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: CircularProgressIndicator(),
                      )
                    else if (state.isFailure)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          state.errorMessage ?? 'Failed to load profile',
                          style: AppTextStyles.bodyMedium.merge(
                            const TextStyle(color: AppColors.error),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else if (state.isLoaded && state.profile != null) ...[
                      _Profile(name: state.profile!.name),

                      _Characteristics(
                        yearsOld: '${state.profile!.age} лет',
                        visitedEventsCount:
                            '${state.profile!.visitedEventsCount} событий',
                      ),

                      const SizedBox(height: 24),

                      Text(
                        'Для редактирования нажмите на выбранное поле',
                        style: AppTextStyles.labelMedium.merge(
                          const TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
