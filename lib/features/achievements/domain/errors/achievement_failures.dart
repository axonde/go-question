enum AchievementFailureType { profileNotFound, fetchFailed, updateFailed }

class AchievementFailure {
  final AchievementFailureType type;
  final String message;

  const AchievementFailure(this.type, {this.message = ''});

  @override
  String toString() => 'AchievementFailure(type: $type, message: $message)';
}
