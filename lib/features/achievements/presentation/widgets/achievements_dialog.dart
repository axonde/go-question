import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/features/achievements/presentation/bloc/achievements_bloc.dart';

class AchievementsDialog extends StatelessWidget {
  const AchievementsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Достижения'),
      content: SizedBox(
        width: 360,
        child: BlocBuilder<AchievementsBloc, AchievementsState>(
          builder: (context, state) {
            if (state.status == AchievementsStatus.loading ||
                state.status == AchievementsStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == AchievementsStatus.failure) {
              return Text(state.errorMessage ?? 'Не удалось загрузить данные');
            }

            return ListView.separated(
              shrinkWrap: true,
              itemCount: state.achievements.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final achievement = state.achievements[index];
                final color = achievement.isUnlocked
                    ? Colors.amber.shade700
                    : Colors.grey.shade500;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    achievement.isUnlocked
                        ? Icons.workspace_premium
                        : Icons.lock_outline,
                    color: color,
                  ),
                  title: Text(achievement.title),
                  subtitle: Text(achievement.description),
                  trailing: achievement.isUnlocked && !achievement.isViewed
                      ? const Icon(
                          Icons.fiber_manual_record,
                          color: Colors.red,
                          size: 10,
                        )
                      : null,
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Закрыть'),
        ),
      ],
    );
  }
}
