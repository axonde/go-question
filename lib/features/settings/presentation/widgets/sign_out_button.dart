import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/router/router.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/settings_texts.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/features/auth/presentation/bloc/auth_bloc.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.select<AuthBloc, AuthState>((bloc) => bloc.state);
    final isLoading = authState.isLoading;
    final isLoggedOut = authState.status == AuthStatus.unauthenticated;

    return GQButton(
      onPressed: () {
        if (isLoggedOut) {
          context.router.push(const AuthFlowRoute());
          return;
        }
        context.read<AuthBloc>().add(const AuthSignOutRequested());
      },
      isLoading: isLoading,
      text: isLoggedOut ? SettingsTexts.signIn : SettingsTexts.signOut,
      widthFactor: 1,
      aspectRatio: 4.8,
      baseColor: isLoggedOut ? AppColors.success : AppColors.redBackground,
      textColor: AppColors.textPrimary,
      textStrokeColor: AppColors.stroke,
      fontSize: UiConstants.textSize * 0.9,
      textShadowColor: Colors.black,
      shadowColor: Colors.black.withValues(alpha: 0.5),
    );
  }
}
