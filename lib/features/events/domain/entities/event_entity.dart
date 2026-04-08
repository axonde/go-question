import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_entity.freezed.dart';

@freezed
class EventEntity with _$EventEntity {
  const factory EventEntity({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required DateTime date,
    required String location,
    required String category,
    required double price,
    required int participants,
    required String organizer,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _EventEntity;
}
