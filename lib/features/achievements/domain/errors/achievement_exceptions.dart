sealed class AchievementException implements Exception {
  final String message;

  const AchievementException(this.message);

  @override
  String toString() => 'AchievementException(message: $message)';
}

final class AchievementProfileNotFoundException extends AchievementException {
  const AchievementProfileNotFoundException()
    : super('Profile not found for achievements operations');
}

final class AchievementFetchException extends AchievementException {
  const AchievementFetchException() : super('Failed to fetch achievements');
}

final class AchievementUpdateException extends AchievementException {
  const AchievementUpdateException() : super('Failed to update achievements');
}
