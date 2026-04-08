/// Firestore collection and field names for Profile feature.
abstract final class ProfileFirestoreConstants {
  static const String usersCollection = 'users';
}

/// Validation error messages for Profile entity.
abstract final class ProfileValidationMessages {
  static const String uidCannotBeEmpty = 'uid cannot be empty';
  static const String nameCannotBeEmpty =
      'name cannot be empty or whitespace-only';
  static const String ageInvalid = 'age must be >= 0, got';
  static const String visitedEventsCountInvalid =
      'visitedEventsCount must be >= 0';
  static const String createdEventsCountInvalid =
      'createdEventsCount must be >= 0';
  static const String incrementByInvalid = 'by must be >= 0, got';
}

/// Failure messages for Profile repository operations and mappers.
abstract final class ProfileFailureMessages {
  static const String profileNotFoundForUid = 'Profile not found for uid:';
  static const String profileNotFoundForUidPattern =
      'Profile not found for uid: '; // For exception mapper
  static const String nameCannotBeEmptyOrWhitespace =
      'Name cannot be empty or whitespace-only';
  static const String profileCreatedButNotFoundOnReadBack =
      'Profile created but not found on read-back';
  static const String profileNotFoundAfterIncrement =
      'Profile not found after increment:';
}
