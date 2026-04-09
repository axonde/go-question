// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationEntityImpl _$$NotificationEntityImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationEntityImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
  isRead: json['isRead'] as bool,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  requestUserId: json['requestUserId'] as String?,
  requestUserName: json['requestUserName'] as String?,
  requestUserRegistrationId: json['requestUserRegistrationId'] as String?,
  requestUserRating: json['requestUserRating'] as String?,
  requestUserAge: json['requestUserAge'] as String?,
  requestUserGender: json['requestUserGender'] as String?,
  requestUserCity: json['requestUserCity'] as String?,
  requestUserBio: json['requestUserBio'] as String?,
  requestUserEventsAttended: (json['requestUserEventsAttended'] as num?)
      ?.toInt(),
  requestUserEventsOrganized: (json['requestUserEventsOrganized'] as num?)
      ?.toInt(),
  eventId: json['eventId'] as String?,
  eventTitle: json['eventTitle'] as String?,
  eventDate: json['eventDate'] as String?,
  eventLocation: json['eventLocation'] as String?,
  eventCategory: json['eventCategory'] as String?,
);

Map<String, dynamic> _$$NotificationEntityImplToJson(
  _$NotificationEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'title': instance.title,
  'body': instance.body,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'isRead': instance.isRead,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'requestUserId': instance.requestUserId,
  'requestUserName': instance.requestUserName,
  'requestUserRegistrationId': instance.requestUserRegistrationId,
  'requestUserRating': instance.requestUserRating,
  'requestUserAge': instance.requestUserAge,
  'requestUserGender': instance.requestUserGender,
  'requestUserCity': instance.requestUserCity,
  'requestUserBio': instance.requestUserBio,
  'requestUserEventsAttended': instance.requestUserEventsAttended,
  'requestUserEventsOrganized': instance.requestUserEventsOrganized,
  'eventId': instance.eventId,
  'eventTitle': instance.eventTitle,
  'eventDate': instance.eventDate,
  'eventLocation': instance.eventLocation,
  'eventCategory': instance.eventCategory,
};

const _$NotificationTypeEnumMap = {
  NotificationType.joinRequest: 'join_request',
  NotificationType.friendRequest: 'friend_request',
  NotificationType.eventReminder: 'event_reminder',
  NotificationType.message: 'message',
  NotificationType.system: 'system',
};
