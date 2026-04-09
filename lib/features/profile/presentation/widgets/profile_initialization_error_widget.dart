import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/router/router.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/app_text_styles.dart';
import 'package:go_question/core/constants/profile_messages.dart';
import 'package:go_question/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:go_question/injection_container/injection_container.dart';

/// Error state widget for profile initialization with retry/logout options.
class ProfileInitializationErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final String? failureDetails;
  static const String _defaultProfileName = 'User';

  const ProfileInitializationErrorWidget({
    super.key,
    this.errorMessage,
    this.failureDetails,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            const Text(
              profileInitializationErrorMessage,
              style: AppTextStyles.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage ?? profileInitializationFailedMessage,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (failureDetails != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: BoxBorder.all(color: AppColors.inputBorder),
                ),
                child: Text(
                  'Error: $failureDetails',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final authBloc = context.read<AuthBloc>();
                      authBloc.add(const AuthSignOutRequested());
                      sl<AppRouter>().replace(const MainRoute());
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Выход'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textSecondary,
                      foregroundColor: AppColors.popupOutBackground,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final authState = context.read<AuthBloc>().state;
                      final user = authState.user;
                      if (user != null) {
                        context.read<ProfileBloc>().add(
                          ProfileRetryRequested(
                            uid: user.uid,
                            initialEmail: user.email,
                            initialName: _defaultProfileName,
                            initialNickname: user.nickname,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Повтор'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
