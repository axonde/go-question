import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/pressable.dart';
import 'package:go_question/features/score/presentation/bloc/score_bloc.dart';

part 'profile_button/profile_avatar.dart';
part 'profile_button/profile_score_badge.dart';
part 'profile_button/profile_user_info.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ProfileButton — карточка профиля на главном экране.
//
// Ответственность: считать размер слота (LayoutBuilder) и скомпоновать части.
// Данные: user из AuthBloc, score из ScoreBloc.
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
    return Builder(
      builder: (context) {
        const name = 'maximka';

        return Builder(
          builder: (context) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF0E3457).withValues(alpha: 0.7),
                border: Border.all(color: const Color(0xFF5EA3D3)),
                borderRadius: BorderRadius.circular(
                  UiConstants.borderRadius * 5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    offset: const Offset(0, 2),
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
                        name: name,
                        nickname:
                            null, // TODO: добавить поле nickname в UserEntity
                        slotHeight: slotHeight,
                      ),
                    ),
                    const SizedBox(width: UiConstants.boxUnit),
                    _ProfileScoreBadge(
                      score: 13, // mock
                      slotHeight: slotHeight,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
