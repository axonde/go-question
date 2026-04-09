import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/core/constants/achievement_constants.dart';
import 'package:go_question/core/widgets/buttons/gq_close_button.dart';
import 'package:go_question/core/widgets/dialogs/gq_dialog_panel.dart';
import 'package:go_question/core/widgets/text/clash_stroke_text.dart';
import 'package:go_question/features/achievements/presentation/bloc/achievements_bloc.dart';

class AchievementsDialog extends StatelessWidget {
  const AchievementsDialog({super.key});

  static const List<_AchievementVisual> _visuals = <_AchievementVisual>[
    _AchievementVisual(
      id: AchievementConstants.firstOpenAchievements,
      unlockedAssetPath: 'assets/images/achievments/open_achievs.png',
      lockedAssetPath: null,
      alwaysUnlocked: true,
    ),
    _AchievementVisual(
      id: AchievementConstants.firstJoinedEvent,
      unlockedAssetPath: 'assets/images/achievments/visite_event.png',
      lockedAssetPath: 'assets/images/achievments/visite_event_lock.png',
    ),
    _AchievementVisual(
      id: AchievementConstants.firstCreatedEvent,
      unlockedAssetPath: 'assets/images/achievments/create_event.png',
      lockedAssetPath: 'assets/images/achievments/create_event_lock.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GqDialogPanel(
      maxHeight: 820,
      child: BlocBuilder<AchievementsBloc, AchievementsState>(
        builder: (context, state) {
          final achievementById = {
            for (final achievement in state.achievements)
              achievement.id: achievement,
          };

          return Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Center(
                      child: ClashStrokeText(
                        'Достижения',
                        fontSize: 24,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            color: Color(0x99000000),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GqCloseButton(onTap: () => Navigator.of(context).pop()),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Builder(
                  builder: (_) {
                    if (state.status == AchievementsStatus.loading ||
                        state.status == AchievementsStatus.initial) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.status == AchievementsStatus.failure) {
                      return Center(
                        child: ClashStrokeText(
                          state.errorMessage ??
                              'Не удалось загрузить достижения',
                          fontSize: 16,
                          maxLines: 2,
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: _visuals.length,
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                      itemBuilder: (context, index) {
                        final visual = _visuals[index];
                        final achievement = achievementById[visual.id];
                        final isUnlocked =
                            visual.alwaysUnlocked ||
                            (achievement?.isUnlocked ?? false);

                        final assetPath = isUnlocked
                            ? visual.unlockedAssetPath
                            : (visual.lockedAssetPath ??
                                  visual.unlockedAssetPath);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Image.asset(assetPath, fit: BoxFit.contain),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AchievementVisual {
  final String id;
  final String unlockedAssetPath;
  final String? lockedAssetPath;
  final bool alwaysUnlocked;

  const _AchievementVisual({
    required this.id,
    required this.unlockedAssetPath,
    required this.lockedAssetPath,
    this.alwaysUnlocked = false,
  });
}
