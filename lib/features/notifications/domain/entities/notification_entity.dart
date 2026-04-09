import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_question/core/utils/timestamp_converter.dart';

part 'notification_entity.freezed.dart';
part 'notification_entity.g.dart';

@freezed
class NotificationEntity with _$NotificationEntity {
  const factory NotificationEntity({
    required String id,
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    required bool isRead,
    @TimestampConverter() required DateTime createdAt,
    // Опциональные поля для запросов на участие
    String? requestUserId,
    String? requestUserName,
    String? requestUserRegistrationId,
    String? requestUserRating,
    String? requestUserAge,
    String? requestUserGender,
    String? requestUserCity,
    String? requestUserBio,
    int? requestUserEventsAttended,
    int? requestUserEventsOrganized,
    // Опциональные поля для событий
    String? eventId,
    String? eventTitle,
    String? eventDate,
    String? eventLocation,
    String? eventCategory,
  }) = _NotificationEntity;

  factory NotificationEntity.fromJson(Map<String, dynamic> json) =>
      _$NotificationEntityFromJson(json);
}

enum NotificationType {
  @JsonValue('join_request')
  joinRequest,
  @JsonValue('friend_request')
  friendRequest,
  @JsonValue('event_reminder')
  eventReminder,
  @JsonValue('message')
  message,
  @JsonValue('system')
  system,
}
