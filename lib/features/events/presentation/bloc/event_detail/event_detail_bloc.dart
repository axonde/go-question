import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/events/domain/repositories/i_events_repository.dart';

import 'event_detail_event.dart';
import 'event_detail_state.dart';

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final IEventsRepository _repository;

  EventDetailBloc(this._repository) : super(const EventDetailState.initial()) {
    on<EventDetailEvent>((event, emit) async {
      await event.map(
        started: (e) => _onStarted(e.id, emit),
        refreshed: (e) => _onRefreshed(e.id, emit),
      );
    });
  }

  Future<void> _onRefreshed(String id, Emitter<EventDetailState> emit) async {
    emit(const EventDetailState.loading());
    final result = await _repository.getEventById(id);
    result.fold(
      onSuccess: (event) => emit(EventDetailState.success(event)),
      onFailure: (failure) => emit(EventDetailState.failure(failure)),
    );
  }

  Future<void> _onStarted(String id, Emitter<EventDetailState> emit) async {
    emit(const EventDetailState.loading());
    final result = await _repository.getEventById(id);
    result.fold(
      onSuccess: (event) => emit(EventDetailState.success(event)),
      onFailure: (failure) => emit(EventDetailState.failure(failure)),
    );
  }
}
