abstract class EventsConstants {
  static const String eventsCollection = 'events';
  static const String eventJoinRequestsCollection = 'event_join_requests';

  static const String fieldId = 'id';
  static const String fieldTitle = 'title';
  static const String fieldDescription = 'description';
  static const String fieldStartTime = 'startTime';
  static const String fieldLocation = 'location';
  static const String fieldCategory = 'category';
  static const String fieldPrice = 'price';
  static const String fieldMaxUsers = 'maxUsers';
  static const String fieldParticipants = 'participants';
  static const String fieldOrganizer = 'organizer';
  static const String fieldStatus = 'status';
  static const String fieldDurationMinutes = 'durationMinutes';
  static const String fieldCreatedAt = 'createdAt';
  static const String fieldUpdatedAt = 'updatedAt';
  static const String fieldImageUrl = 'imageUrl';
  static const String fieldParticipantIds = 'participantIds';
  static const String fieldPendingParticipantIds = 'pendingParticipantIds';
  static const String fieldRejectedParticipantIds = 'rejectedParticipantIds';
  static const String fieldRequiresApproval = 'requiresApproval';
  static const String fieldVisibility = 'visibility';
  static const String fieldJoinMode = 'joinMode';

  static const String joinRequestFieldId = 'id';
  static const String joinRequestFieldEventId = 'eventId';
  static const String joinRequestFieldRequesterId = 'requesterId';
  static const String joinRequestFieldOrganizerId = 'organizerId';
  static const String joinRequestFieldStatus = 'status';
  static const String joinRequestFieldCreatedAt = 'createdAt';
  static const String joinRequestFieldUpdatedAt = 'updatedAt';
  static const String joinRequestFieldReviewedAt = 'reviewedAt';
  static const String joinRequestFieldReviewedBy = 'reviewedBy';

  static const String statusOpen = 'open';
  static const String statusUpcoming = 'upcoming';
  static const String statusCancelled = 'cancelled';
  static const String statusCompleted = 'completed';
  static const int defaultDurationMinutes = 60;

  static const String joinModeOpen = 'open';
  static const String joinModeRequest = 'request';
  static const String joinModeInvite = 'invite';

  static const String visibilityPublic = 'public';
  static const String visibilityFriends = 'friends';
  static const String visibilityPrivate = 'private';

  static const String joinRequestStatusPending = 'pending';
  static const String joinRequestStatusApproved = 'approved';
  static const String joinRequestStatusRejected = 'rejected';
  static const String joinRequestStatusCancelled = 'cancelled';
}
