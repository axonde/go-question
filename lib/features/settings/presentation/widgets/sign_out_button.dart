import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/settings_texts.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/features/auth/presentation/bloc/auth_bloc.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GQButton(
      onPressed: () =>
          context.read<AuthBloc>().add(const AuthSignOutRequested()),
      text: SettingsTexts.signOut,
      widthFactor: 1,
      aspectRatio: 4.8,
      baseColor: AppColors.redBackground,
      textColor: AppColors.textPrimary,
      textStrokeColor: AppColors.stroke,
      fontSize: UiConstants.textSize * 0.9,
      textShadowColor: Colors.black,
      shadowColor: Colors.black.withValues(alpha: 0.5),
    );
  }
}
