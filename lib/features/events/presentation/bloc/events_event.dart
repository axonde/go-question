part of 'events_bloc.dart';

sealed class EventsEvent {
  const EventsEvent();
}

final class EventsSearchStarted extends EventsEvent {
  const EventsSearchStarted();
}

final class EventsSearchRefreshed extends EventsEvent {
  const EventsSearchRefreshed();
}

final class EventsDetailRequested extends EventsEvent {
  final String id;

  const EventsDetailRequested(this.id);
}

final class EventsCreateSubmitted extends EventsEvent {
  final EventEntity event;

  const EventsCreateSubmitted(this.event);
}

final class EventsPageChanged extends EventsEvent {
  final EventsPage page;

  const EventsPageChanged(this.page);
}

final class EventsTransientCleared extends EventsEvent {
  const EventsTransientCleared();
}
