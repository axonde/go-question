import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';

part 'event_create_event.freezed.dart';

@freezed
class EventCreateEvent with _$EventCreateEvent {
  const factory EventCreateEvent.submitted(EventEntity event) = _Submitted;
}
