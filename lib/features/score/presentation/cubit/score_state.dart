part of 'score_cubit.dart';

/// Единственное состояние — текущее значение кубков.
/// Cubit всегда инициализирован, поэтому отдельный «Loading» не нужен.
final class ScoreState {
  final int value;
  const ScoreState(this.value);
}
