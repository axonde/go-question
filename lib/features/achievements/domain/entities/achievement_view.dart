class AchievementView {
  final String id;
  final String title;
  final String description;
  final bool isUnlocked;
  final bool isViewed;

  const AchievementView({
    required this.id,
    required this.title,
    required this.description,
    required this.isUnlocked,
    required this.isViewed,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AchievementView &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.isUnlocked == isUnlocked &&
        other.isViewed == isViewed;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        isUnlocked.hashCode ^
        isViewed.hashCode;
  }
}
