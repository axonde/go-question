import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/features/events/domain/repositories/i_events_repository.dart';
import 'package:go_question/core/types/result.dart';
import 'events_search_event.dart';
import 'events_search_state.dart';

class EventsSearchBloc extends Bloc<EventsSearchEvent, EventsSearchState> {
  final IEventsRepository _repository;

  EventsSearchBloc(this._repository)
    : super(const EventsSearchState.initial()) {
    on<EventsSearchEvent>((event, emit) async {
      await event.map(
        started: (_) => _onStarted(emit),
        refreshed: (_) => _onRefreshed(emit),
      );
    });
  }

  Future<void> _onStarted(Emitter<EventsSearchState> emit) async {
    emit(const EventsSearchState.loading());
    final result = await _repository.getEvents();
    result.fold(
      onSuccess: (events) => emit(EventsSearchState.success(events)),
      onFailure: (failure) => emit(EventsSearchState.failure(failure)),
    );
  }

  Future<void> _onRefreshed(Emitter<EventsSearchState> emit) async {
    emit(const EventsSearchState.loading());
    final result = await _repository.getEvents();
    result.fold(
      onSuccess: (events) => emit(EventsSearchState.success(events)),
      onFailure: (failure) => emit(EventsSearchState.failure(failure)),
    );
  }
}
