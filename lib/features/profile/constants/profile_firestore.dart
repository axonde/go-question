/// Firestore collection and field names for Profile feature.
abstract final class ProfileFirestoreConstants {
  static const String usersCollection = 'users';
  static const String nicknamesCollection = 'nicknames';
  static const String friendRequestsCollection = 'friend_requests';
  static const String countersCollection = 'counters';
  static const String userRegistrationCounterDoc = 'user_registration';

  static const String fieldUid = 'uid';
  static const String fieldRegistrationId = 'registrationId';
  static const String fieldEmail = 'email';
  static const String fieldName = 'name';
  static const String fieldNickname = 'nickname';
  static const String fieldBirthDate = 'birthDate';
  static const String fieldCity = 'city';
  static const String fieldBio = 'bio';
  static const String fieldAvatarUrl = 'avatarUrl';
  static const String fieldGender = 'gender';
  static const String fieldAge = 'age';
  static const String fieldRating = 'rating';
  static const String fieldTrophies = 'trophies';
  static const String fieldVisitedEventsCount = 'visitedEventsCount';
  static const String fieldCreatedEventsCount = 'createdEventsCount';
  static const String fieldJoinedEventIds = 'joinedEventIds';
  static const String fieldCreatedEventIds = 'createdEventIds';
  static const String fieldFriendIds = 'friendIds';
  static const String fieldIncomingFriendRequestIds =
      'incomingFriendRequestIds';
  static const String fieldOutgoingFriendRequestIds =
      'outgoingFriendRequestIds';
  static const String fieldBlockedUserIds = 'blockedUserIds';
  static const String fieldLastSeenAt = 'lastSeenAt';
  static const String fieldCreatedAt = 'createdAt';
  static const String fieldUpdatedAt = 'updatedAt';

  static const String friendRequestFieldId = 'id';
  static const String friendRequestFieldRequesterId = 'requesterId';
  static const String friendRequestFieldRecipientId = 'recipientId';
  static const String friendRequestFieldStatus = 'status';
  static const String friendRequestFieldMessage = 'message';
  static const String friendRequestFieldCreatedAt = 'createdAt';
  static const String friendRequestFieldUpdatedAt = 'updatedAt';
  static const String friendRequestFieldReviewedAt = 'reviewedAt';
  static const String friendRequestFieldReviewedBy = 'reviewedBy';
}

/// Validation error messages for Profile entity.
abstract final class ProfileValidationMessages {
  static const String uidCannotBeEmpty = 'uid cannot be empty';
  static const String registrationIdInvalid = 'registrationId must be >= 1000';
  static const String emailCannotBeEmpty = 'email cannot be empty';
  static const String nameCannotBeEmpty =
      'name cannot be empty or whitespace-only';
  static const String nicknameCannotBeEmpty =
      'nickname cannot be empty or whitespace-only';
  static const String nicknameAlreadyTaken = 'nickname is already taken';
  static const String birthDateInFuture =
      'birthDate cannot be in the future, got';
  static const String trophiesInvalid = 'trophies must be >= 0';
  static const String visitedEventsCountInvalid =
      'visitedEventsCount must be >= 0';
  static const String createdEventsCountInvalid =
      'createdEventsCount must be >= 0';
  static const String eventIdCannotBeEmpty =
      'event id cannot be empty or whitespace-only';
  static const String incrementByInvalid = 'by must be >= 0, got';
}

/// Failure messages for Profile repository operations and mappers.
abstract final class ProfileFailureMessages {
  static const String profileNotFoundForUid = 'Profile not found for uid:';
  static const String profileNotFoundForUidPattern =
      'Profile not found for uid: '; // For exception mapper
  static const String nameCannotBeEmptyOrWhitespace =
      'Name cannot be empty or whitespace-only';
  static const String nicknameIsImmutable =
      'Nickname cannot be changed after registration';
  static const String profileCreatedButNotFoundOnReadBack =
      'Profile created but not found on read-back';
  static const String profileNotFoundAfterIncrement =
      'Profile not found after increment:';
}
