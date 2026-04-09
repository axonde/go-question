import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/router/router.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/event_texts.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/features/profile/constants/profile_presentation.dart';
import 'package:go_question/features/profile/domain/entities/profile.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:go_question/features/profile/presentation/widgets/profile_initialization_error_widget.dart';
import 'package:go_question/features/profile/presentation/widgets/profile_initialization_loading_widget.dart';
import 'package:go_question/injection_container/injection_container.dart';

part '../widgets/profile_initialization/profile_completion_form.dart';

@RoutePage()
class ProfileInitializationPage extends StatefulWidget {
  const ProfileInitializationPage({super.key});

  @override
  State<ProfileInitializationPage> createState() =>
      _ProfileInitializationPageState();
}

class _ProfileInitializationPageState extends State<ProfileInitializationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.popupOutBackground,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.isSuccess &&
            current.profile != null &&
            !_needsProfileCompletion(current.profile!),
        listener: (context, state) {
          if (state.isSuccess &&
              state.profile != null &&
              !_needsProfileCompletion(state.profile!) &&
              context.mounted) {
            sl<AppRouter>().replace(const MainRoute());
          }
        },
        builder: (context, state) {
          if (state.isLoading || state.status == ProfileStatus.initial) {
            return const ProfileInitializationLoadingWidget();
          }

          if (state.isRecoverableFailure) {
            return ProfileInitializationErrorWidget(
              errorMessage: state.errorMessage,
              failureDetails: state.failureDetails,
            );
          }

          final profile = state.profile;
          if (state.isSuccess &&
              profile != null &&
              _needsProfileCompletion(profile)) {
            return _ProfileCompletionForm(profile: profile);
          }

          return const ProfileInitializationLoadingWidget();
        },
      ),
    );
  }

  static bool _needsProfileCompletion(Profile profile) {
    return profile.birthDate == null ||
        (profile.city?.trim().isEmpty ?? true) ||
        (profile.gender?.trim().isEmpty ?? true);
  }
}
