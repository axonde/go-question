import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_detail_event.freezed.dart';

@freezed
class EventDetailEvent with _$EventDetailEvent {
  const factory EventDetailEvent.started(String id) = _Started;
  const factory EventDetailEvent.refreshed(String id) = _Refreshed;
}
