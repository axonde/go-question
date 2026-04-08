import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';

extension EventModelX on EventEntity {
  static EventEntity fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('Document data was null');
    }
    data['id'] = snapshot.id;
    return EventEntity.fromJson(data);
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }
}
