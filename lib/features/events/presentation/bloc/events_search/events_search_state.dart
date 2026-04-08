import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/domain/errors/event_failures.dart';

part 'events_search_state.freezed.dart';

@freezed
class EventsSearchState with _$EventsSearchState {
  const factory EventsSearchState.initial() = _Initial;
  const factory EventsSearchState.loading() = _Loading;
  const factory EventsSearchState.success(List<EventEntity> events) = _Success;
  const factory EventsSearchState.failure(EventFailure failure) = _Failure;
}
