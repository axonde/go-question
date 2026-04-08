part of 'score_bloc.dart';

/// Единственное состояние — текущее значение кубков.
/// BLoC всегда инициализирован, поэтому отдельный «Loading» не нужен.
final class ScoreState {
  final int value;
  const ScoreState(this.value);
}
