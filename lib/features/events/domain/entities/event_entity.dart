import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_question/core/utils/timestamp_converter.dart';

part 'event_entity.freezed.dart';
part 'event_entity.g.dart';

@freezed
class EventEntity with _$EventEntity {
  const factory EventEntity({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    @TimestampConverter() required DateTime startTime,
    required String location,
    required String category,
    required double price,
    required int maxUsers,
    required int participants,
    required String organizer,
    required String status,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _EventEntity;

  factory EventEntity.fromJson(Map<String, dynamic> json) =>
      _$EventEntityFromJson(json);
}
