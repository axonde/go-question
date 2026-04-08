import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/domain/errors/event_failures.dart';

part 'event_detail_state.freezed.dart';

@freezed
class EventDetailState with _$EventDetailState {
  const factory EventDetailState.initial() = _Initial;
  const factory EventDetailState.loading() = _Loading;
  const factory EventDetailState.success(EventEntity event) = _Success;
  const factory EventDetailState.failure(EventFailure failure) = _Failure;
}
