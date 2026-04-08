import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/core/types/result.dart';

import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/i_events_repository.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final IEventsRepository _repository;

  EventsBloc(this._repository) : super(const EventsState.initial()) {
    on<EventsSearchStarted>(_onSearchStarted);
    on<EventsSearchRefreshed>(_onSearchRefreshed);
    on<EventsDetailRequested>(_onDetailRequested);
    on<EventsCreateSubmitted>(_onCreateSubmitted);
    on<EventsPageChanged>(_onPageChanged);
    on<EventsTransientCleared>(_onTransientCleared);
  }

  Future<void> _onSearchStarted(
    EventsSearchStarted event,
    Emitter<EventsState> emit,
  ) async {
    emit(_loadingState());

    final result = await _repository.getEvents();

    result.fold(
      onSuccess: (events) {
        emit(
          state.copyWith(
            status: EventsStatus.success,
            events: events,
            clearError: true,
            clearHint: true,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: EventsStatus.failure,
            errorMessage: failure.message,
            clearHint: true,
          ),
        );
      },
    );
  }

  Future<void> _onSearchRefreshed(
    EventsSearchRefreshed event,
    Emitter<EventsState> emit,
  ) async {
    emit(_loadingState());

    final result = await _repository.getEvents();

    result.fold(
      onSuccess: (events) {
        emit(
          state.copyWith(
            status: EventsStatus.success,
            events: events,
            clearError: true,
            clearHint: true,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: EventsStatus.failure,
            errorMessage: failure.message,
            clearHint: true,
          ),
        );
      },
    );
  }

  Future<void> _onDetailRequested(
    EventsDetailRequested event,
    Emitter<EventsState> emit,
  ) async {
    emit(_loadingState());

    final result = await _repository.getEventById(event.id);

    result.fold(
      onSuccess: (eventData) {
        emit(
          state.copyWith(
            status: EventsStatus.success,
            currentEvent: eventData,
            clearError: true,
            clearHint: true,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: EventsStatus.failure,
            errorMessage: failure.message,
            clearHint: true,
          ),
        );
      },
    );
  }

  Future<void> _onCreateSubmitted(
    EventsCreateSubmitted event,
    Emitter<EventsState> emit,
  ) async {
    emit(_loadingState());

    final result = await _repository.createEvent(event.event);

    result.fold(
      onSuccess: (_) {
        emit(
          state.copyWith(
            status: EventsStatus.success,
            clearError: true,
            clearHint: true,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: EventsStatus.failure,
            errorMessage: failure.message,
            clearHint: true,
          ),
        );
      },
    );
  }

  void _onPageChanged(EventsPageChanged event, Emitter<EventsState> emit) {
    emit(
      state.copyWith(
        currentPage: event.page,
        status: EventsStatus.initial,
        clearError: true,
        clearHint: true,
      ),
    );
  }

  void _onTransientCleared(
    EventsTransientCleared event,
    Emitter<EventsState> emit,
  ) {
    emit(state.copyWith(clearError: true, clearHint: true));
  }

  EventsState _loadingState() {
    return state.copyWith(
      status: EventsStatus.loading,
      clearError: true,
      clearHint: true,
    );
  }
}
