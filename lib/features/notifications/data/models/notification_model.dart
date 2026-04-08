import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_question/features/notifications/domain/entities/notification_entity.dart';

extension NotificationModelX on NotificationEntity {
  static NotificationEntity fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('Document data was null');
    }
    data['id'] = snapshot.id;
    return NotificationEntity.fromJson(data);
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }
}
