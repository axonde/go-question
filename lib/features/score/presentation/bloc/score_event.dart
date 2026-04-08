part of 'score_bloc.dart';

sealed class ScoreEvent {
  const ScoreEvent();
}

/// Событие начисления очков за создание ивента.
final class ScoreEventAdded extends ScoreEvent {
  const ScoreEventAdded();
}

/// Событие установки конкретного значения очков.
final class ScoreValueSet extends ScoreEvent {
  final int value;

  const ScoreValueSet(this.value);
}
