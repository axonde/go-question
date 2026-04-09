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

final class EventsJoinRequested extends EventsEvent {
  final String eventId;
  final String requesterId;

  const EventsJoinRequested({required this.eventId, required this.requesterId});
}

final class EventsJoinRequestApproved extends EventsEvent {
  final String requestId;
  final String organizerId;

  const EventsJoinRequestApproved({
    required this.requestId,
    required this.organizerId,
  });
}

final class EventsJoinRequestRejected extends EventsEvent {
  final String requestId;
  final String organizerId;

  const EventsJoinRequestRejected({
    required this.requestId,
    required this.organizerId,
  });
}

final class EventsLeaveRequested extends EventsEvent {
  final String eventId;
  final String userId;

  const EventsLeaveRequested({required this.eventId, required this.userId});
}

final class EventsParticipantRemoveRequested extends EventsEvent {
  final String eventId;
  final String userId;

  const EventsParticipantRemoveRequested({
    required this.eventId,
    required this.userId,
  });
}

final class EventsPageChanged extends EventsEvent {
  final EventsPage page;

  const EventsPageChanged(this.page);
}

final class EventsTransientCleared extends EventsEvent {
  const EventsTransientCleared();
}
