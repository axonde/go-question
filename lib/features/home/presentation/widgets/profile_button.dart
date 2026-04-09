import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/home_ui_constants.dart';
import 'package:go_question/core/widgets/pressable.dart';
import 'package:go_question/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_question/features/profile/constants/profile_presentation.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:go_question/features/score/presentation/bloc/score_bloc.dart';

part 'profile_button/profile_avatar.dart';
part 'profile_button/profile_score_badge.dart';
part 'profile_button/profile_user_info.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ProfileButton — карточка профиля на главном экране.
//
// Ответственность: считать размер слота (LayoutBuilder) и скомпоновать части.
// Данные: profile из ProfileBloc.
// ─────────────────────────────────────────────────────────────────────────────

class ProfileButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ProfileButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final vPad = h * 0.12;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UiConstants.leftPadding * 2,
          ),
          child: Pressable(
            onTap: onPressed ?? () {},
            child: _ProfileCard(slotHeight: h - vPad * 2),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ProfileCard — контейнер карточки.
// Получает данные из BLoC и передаёт вниз plain-параметрами (SRP).
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final double slotHeight;

  const _ProfileCard({required this.slotHeight});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileBloc>().state.profile;
    final authUser = context.watch<AuthBloc>().state.user;
    final profileName = profile?.name.trim();
    final authNickname = authUser?.nickname.trim() ?? '';
    final registrationId = profile?.registrationId;
    final safeName = authUser == null
        ? 'Войти'
        : ((profileName == null || profileName.isEmpty)
              ? (authNickname.isNotEmpty
                    ? authNickname
                    : ProfilePresentationConstants.displayNameFallback)
              : profileName);
    final idLabel = authUser == null
        ? 'Для доступа к профилю'
        : registrationId == null
        ? 'ID: —'
        : 'ID: $registrationId';
    final profileScore = profile?.trophies ?? 0;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: HomeUiConstants.panelBackground.withValues(alpha: 0.7),
        border: Border.all(color: HomeUiConstants.participantAccent),
        borderRadius: BorderRadius.circular(UiConstants.borderRadius * 5),
        boxShadow: [
          BoxShadow(
            color: HomeUiConstants.panelShadow.withValues(alpha: 0.6),
            offset: const Offset(0, HomeUiConstants.cardShadowOffset),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UiConstants.leftPadding * 1.5,
        ),
        child: Row(
          children: [
            _ProfileAvatar(size: slotHeight * 0.72),
            const SizedBox(width: UiConstants.boxUnit),
            Expanded(
              child: _ProfileUserInfo(
                name: safeName,
                idLabel: idLabel,
                slotHeight: slotHeight,
              ),
            ),
            const SizedBox(width: UiConstants.boxUnit),
            _ProfileScoreBadge(score: profileScore, slotHeight: slotHeight),
          ],
        ),
      ),
    );
  }
}
