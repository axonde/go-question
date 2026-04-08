import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'score_event.dart';
part 'score_state.dart';

/// Управляет «кубками» пользователя.
///
/// Очки начисляются при создании ивента — случайное значение от 20 до 40.
/// Максимум: [maxScore]. При достижении максимума значение фиксируется.
class ScoreBloc extends Bloc<ScoreEvent, ScoreState> {
  static const int maxScore = 99999;

  ScoreBloc() : super(const ScoreState(0)) {
    on<ScoreEventAdded>(_onEventAdded);
    on<ScoreValueSet>(_onValueSet);
  }

  /// Вызывается при создании ивента. Начисляет 20–40 очков.
  void _onEventAdded(ScoreEventAdded event, Emitter<ScoreState> emit) {
    final current = state.value;
    if (current >= maxScore) return;

    final points = 20 + Random().nextInt(21);
    emit(ScoreState((current + points).clamp(0, maxScore)));
  }

  /// Прямая установка значения (например, при загрузке из Firestore).
  void _onValueSet(ScoreValueSet event, Emitter<ScoreState> emit) {
    emit(ScoreState(event.value.clamp(0, maxScore)));
  }
}
