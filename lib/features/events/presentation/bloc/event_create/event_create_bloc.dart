import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/domain/repositories/i_events_repository.dart';
import 'package:go_question/core/types/result.dart';
import 'event_create_event.dart';
import 'event_create_state.dart';

class EventCreateBloc extends Bloc<EventCreateEvent, EventCreateState> {
  final IEventsRepository _repository;

  EventCreateBloc(this._repository) : super(const EventCreateState.initial()) {
    on<EventCreateEvent>((event, emit) async {
      await event.map(submitted: (e) => _onSubmitted(e.event, emit));
    });
  }

  Future<void> _onSubmitted(
    EventEntity event,
    Emitter<EventCreateState> emit,
  ) async {
    emit(const EventCreateState.loading());
    final result = await _repository.createEvent(event);
    result.fold(
      onSuccess: (_) => emit(const EventCreateState.success()),
      onFailure: (failure) => emit(EventCreateState.failure(failure)),
    );
  }
}
