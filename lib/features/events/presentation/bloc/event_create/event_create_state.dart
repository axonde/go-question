import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_question/features/events/domain/errors/event_failures.dart';

part 'event_create_state.freezed.dart';

@freezed
class EventCreateState with _$EventCreateState {
  const factory EventCreateState.initial() = _Initial;
  const factory EventCreateState.loading() = _Loading;
  const factory EventCreateState.success() = _Success;
  const factory EventCreateState.failure(EventFailure failure) = _Failure;
}
