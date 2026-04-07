import 'package:go_question/features/profile/domain/entities/user_profile_entity.dart';

class UserProfileModel {
  final String uid;
  final String name;
  final int age;
  final int visitedEventsCount;

  const UserProfileModel({
    required this.uid,
    required this.name,
    required this.age,
    required this.visitedEventsCount,
  });

  factory UserProfileModel.fromFirestore(
    String uid,
    Map<String, dynamic> data,
  ) {
    final name = data['name'] as String?;
    if (name == null || name.isEmpty) {
      throw const FormatException('Missing required field: name');
    }
    return UserProfileModel(
      uid: uid,
      name: name,
      age: data['age'] as int? ?? 0,
      visitedEventsCount: data['visitedEventsCount'] as int? ?? 0,
    );
  }

  UserProfile toEntity() {
    return UserProfile(
      uid: uid,
      name: name,
      age: age,
      visitedEventsCount: visitedEventsCount,
    );
  }
}
