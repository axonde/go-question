import 'package:freezed_annotation/freezed_annotation.dart';

part 'events_search_event.freezed.dart';

@freezed
class EventsSearchEvent with _$EventsSearchEvent {
  const factory EventsSearchEvent.started() = _Started;
  const factory EventsSearchEvent.refreshed() = _Refreshed;
}
