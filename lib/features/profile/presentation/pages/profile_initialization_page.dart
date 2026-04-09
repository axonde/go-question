import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/router/router.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:go_question/features/profile/presentation/widgets/profile_initialization_error_widget.dart';
import 'package:go_question/features/profile/presentation/widgets/profile_initialization_loading_widget.dart';

/// Profile Initialization Page
///
/// **Purpose:** Ensure profile exists before granting access to main app.
///
/// **UX States:**
/// 1. **Loading** - Profile creation in progress
///    - Show spinner + message
///    - No user interaction possible
///
/// 2. **Success** - Profile created/exists
///    - Auto-transition to MainRoute
///    - No manual action needed
///
/// 3. **Recoverable Failure** - Creation failed (network, server, etc.)
///    - Show error message
///    - Provide explicit Retry button
///    - User NOT logged out (can retry)
///
/// **Critical UX Constraints:**
/// * Never logout on partial failure (auth succeeds but profile fails)
/// * Retry is idempotent - safe to call multiple times
/// * User can keep retrying until success
/// * Profile.name is source of truth (not Auth.displayName)
@RoutePage()
class ProfileInitializationPage extends StatelessWidget {
  const ProfileInitializationPage({super.key});
  static const String _defaultProfileName = 'User';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.popupOutBackground,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listenWhen: (previous, current) {
          // Trigger initial event on first build when bloc is still in initial state
          if (previous.status == ProfileStatus.initial &&
              current.status == ProfileStatus.initial) {
            // Only trigger once - when page first mounts
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final authState = context.read<AuthBloc>().state;
              final user = authState.user;
              if (user != null) {
                context.read<ProfileBloc>().add(
                  EnsureProfileExistsRequested(
                    uid: user.uid,
                    initialEmail: user.email,
                    initialName: _defaultProfileName,
                    initialNickname: user.nickname,
                  ),
                );
              }
            });
          }

          // Listen for success to navigate
          return previous.status != current.status && current.isSuccess;
        },
        listener: (context, state) {
          if (state.isSuccess) {
            context.read<AppRouter>().replace(const MainRoute());
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const ProfileInitializationLoadingWidget();
          }

          if (state.isRecoverableFailure) {
            return ProfileInitializationErrorWidget(
              errorMessage: state.errorMessage,
              failureDetails: state.failureDetails,
            );
          }

          // Initial state (shouldn't reach here normally)
          return const ProfileInitializationLoadingWidget();
        },
      ),
    );
  }
}
