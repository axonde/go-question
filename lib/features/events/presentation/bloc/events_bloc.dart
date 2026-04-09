import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/core/types/result.dart';

import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/i_events_repository.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final IEventsRepository _repository;
  StreamSubscription<List<EventEntity>>? _eventsSubscription;

  EventsBloc(this._repository) : super(const EventsState.initial()) {
    on<_EventsStreamUpdated>(_onEventsStreamUpdated);
    on<EventsSearchStarted>(_onSearchStarted);
    on<EventsSearchRefreshed>(_onSearchRefreshed);
    on<EventsDetailRequested>(_onDetailRequested);
    on<EventsCreateSubmitted>(_onCreateSubmitted);
    on<EventsUpdateSubmitted>(_onUpdateSubmitted);
    on<EventsDeleteRequested>(_onDeleteRequested);
    on<EventsJoinRequested>(_onJoinRequested);
    on<EventsJoinRequestApproved>(_onJoinRequestApproved);
    on<EventsJoinRequestRejected>(_onJoinRequestRejected);
    on<EventsLeaveRequested>(_onLeaveRequested);
    on<EventsParticipantRemoveRequested>(_onParticipantRemoveRequested);
    on<EventsPageChanged>(_onPageChanged);
    on<EventsTransientCleared>(_onTransientCleared);
  }

  Future<void> _onSearchStarted(
    EventsSearchStarted event,
    Emitter<EventsState> emit,
  ) async {
    emit(_loadingState());
    await _eventsSubscription?.cancel();
    _eventsSubscription = _repository.watchEvents().listen(
      (events) => add(_EventsStreamUpdated(events)),
    );

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

  void _onEventsStreamUpdated(
    _EventsStreamUpdated event,
    Emitter<EventsState> emit,
  ) {
    emit(
      state.copyWith(
        status: EventsStatus.success,
        events: event.events,
        clearError: true,
        clearHint: true,
      ),
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

    await result.foldAsync(
      onSuccess: (_) async {
        await _refreshEvents(emit);
      },
      onFailure: (failure) async {
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

  Future<void> _onUpdateSubmitted(
    EventsUpdateSubmitted event,
    Emitter<EventsState> emit,
  ) async {
    emit(_loadingState());

    final result = await _repository.updateEvent(event.event);

    await result.foldAsync(
      onSuccess: (_) async {
        await _refreshEvents(emit);
      },
      onFailure: (failure) async {
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

  Future<void> _onJoinRequested(
    EventsJoinRequested event,
    Emitter<EventsState> emit,
  ) async {
    emit(_loadingState());

    final result = await _repository.requestJoinEvent(
      eventId: event.eventId,
      requesterId: event.requesterId,
    );

    await result.foldAsync(
      onSuccess: (_) async {
        await _refreshEvents(emit);
      },
      onFailure: (failure) async {
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

  Future<void> _onDeleteRequested(
    EventsDeleteRequested event,
    Emitter<EventsState> emit,
  ) async {
    emit(_loadingState());

    final result = await _repository.deleteEvent(event.eventId);

    await result.foldAsync(
      onSuccess: (_) async {
        await _refreshEvents(emit);
      },
      onFailure: (failure) async {
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

  Future<void> _onJoinRequestApproved(
    EventsJoinRequestApproved event,
    Emitter<EventsState> emit,
  ) async {
    emit(_loadingState());

    final result = await _repository.approveJoinRequest(
      requestId: event.requestId,
      organizerId: event.organizerId,
    );

    await result.foldAsync(
      onSuccess: (_) async {
        await _refreshEvents(emit);
      },
      onFailure: (failure) async {
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

  Future<void> _onJoinRequestRejected(
    EventsJoinRequestRejected event,
    Emitter<EventsState> emit,
  ) async {
    emit(_loadingState());

    final result = await _repository.rejectJoinRequest(
      requestId: event.requestId,
      organizerId: event.organizerId,
    );

    await result.foldAsync(
      onSuccess: (_) async {
        await _refreshEvents(emit);
      },
      onFailure: (failure) async {
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

  Future<void> _onLeaveRequested(
    EventsLeaveRequested event,
    Emitter<EventsState> emit,
  ) async {
    emit(_loadingState());

    final result = await _repository.leaveEvent(
      eventId: event.eventId,
      userId: event.userId,
    );

    await result.foldAsync(
      onSuccess: (_) async {
        await _refreshEvents(emit);
      },
      onFailure: (failure) async {
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

  Future<void> _onParticipantRemoveRequested(
    EventsParticipantRemoveRequested event,
    Emitter<EventsState> emit,
  ) async {
    emit(_loadingState());

    final result = await _repository.removeParticipant(
      eventId: event.eventId,
      userId: event.userId,
    );

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

  Future<void> _refreshEvents(Emitter<EventsState> emit) async {
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

  @override
  Future<void> close() async {
    await _eventsSubscription?.cancel();
    return super.close();
  }
}
