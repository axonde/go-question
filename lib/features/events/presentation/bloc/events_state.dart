part of 'events_bloc.dart';

enum EventsStatus { initial, loading, success, failure }

enum EventsPage { search, detail, create }

class EventsState {
  final EventsStatus status;
  final EventsPage currentPage;

  // Search data
  final List<EventEntity> events;

  // Detail data
  final EventEntity? currentEvent;

  // Shared
  final String? errorMessage;
  final String? hintMessage;

  const EventsState({
    required this.status,
    this.currentPage = EventsPage.search,
    this.events = const [],
    this.currentEvent,
    this.errorMessage,
    this.hintMessage,
  });

  const EventsState.initial()
    : status = EventsStatus.initial,
      currentPage = EventsPage.search,
      events = const [],
      currentEvent = null,
      errorMessage = null,
      hintMessage = null;

  bool get isLoading => status == EventsStatus.loading;

  EventsState copyWith({
    EventsStatus? status,
    EventsPage? currentPage,
    List<EventEntity>? events,
    EventEntity? currentEvent,
    String? errorMessage,
    String? hintMessage,
    bool clearCurrentEvent = false,
    bool clearError = false,
    bool clearHint = false,
  }) {
    return EventsState(
      status: status ?? this.status,
      currentPage: currentPage ?? this.currentPage,
      events: events ?? this.events,
      currentEvent: clearCurrentEvent
          ? null
          : (currentEvent ?? this.currentEvent),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      hintMessage: clearHint ? null : (hintMessage ?? this.hintMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventsState &&
        other.status == status &&
        other.currentPage == currentPage &&
        other.currentEvent == currentEvent &&
        other.errorMessage == errorMessage &&
        other.hintMessage == hintMessage &&
        _listEquals(other.events, events);
  }

  @override
  int get hashCode {
    return status.hashCode ^
        currentPage.hashCode ^
        events.hashCode ^
        currentEvent.hashCode ^
        errorMessage.hashCode ^
        hintMessage.hashCode;
  }

  bool _listEquals(List<EventEntity> a, List<EventEntity> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
