import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'score_state.dart';

/// Управляет «кубками» пользователя.
///
/// Очки начисляются при создании ивента — случайное значение от 20 до 40.
/// Максимум: [maxScore]. При достижении максимума значение фиксируется.
class ScoreCubit extends Cubit<ScoreState> {
  static const int maxScore = 99999;

  ScoreCubit() : super(const ScoreState(0));

  /// Вызывается при создании ивента. Начисляет 20–40 очков.
  void addEventScore() {
    final current = state.value;
    if (current >= maxScore) return;

    final points = 20 + Random().nextInt(21);
    emit(ScoreState((current + points).clamp(0, maxScore)));
  }

  /// Прямая установка значения (например, при загрузке из Firestore).
  void setValue(int value) {
    emit(ScoreState(value.clamp(0, maxScore)));
  }
}
