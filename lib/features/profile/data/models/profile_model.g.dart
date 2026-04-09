// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileModelImpl _$$ProfileModelImplFromJson(Map<String, dynamic> json) =>
    _$ProfileModelImpl(
      uid: json['uid'] as String,
      registrationId: (json['registrationId'] as num).toInt(),
      email: json['email'] as String,
      name: json['name'] as String,
      nickname: json['nickname'] as String,
      birthDate: const TimestampConverter().fromJson(json['birthDate']),
      city: json['city'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      gender: json['gender'] as String?,
      age: (json['age'] as num?)?.toInt(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      trophies: (json['trophies'] as num?)?.toInt() ?? 0,
      visitedEventsCount: (json['visitedEventsCount'] as num?)?.toInt() ?? 0,
      createdEventsCount: (json['createdEventsCount'] as num?)?.toInt() ?? 0,
      joinedEventIds:
          (json['joinedEventIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      createdEventIds:
          (json['createdEventIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      friendIds:
          (json['friendIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      incomingFriendRequestIds:
          (json['incomingFriendRequestIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      outgoingFriendRequestIds:
          (json['outgoingFriendRequestIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      blockedUserIds:
          (json['blockedUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      lastSeenAt: const TimestampConverter().fromJson(json['lastSeenAt']),
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$ProfileModelImplToJson(_$ProfileModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'registrationId': instance.registrationId,
      'email': instance.email,
      'name': instance.name,
      'nickname': instance.nickname,
      'birthDate': _$JsonConverterToJson<dynamic, DateTime>(
        instance.birthDate,
        const TimestampConverter().toJson,
      ),
      'city': instance.city,
      'bio': instance.bio,
      'avatarUrl': instance.avatarUrl,
      'gender': instance.gender,
      'age': instance.age,
      'rating': instance.rating,
      'trophies': instance.trophies,
      'visitedEventsCount': instance.visitedEventsCount,
      'createdEventsCount': instance.createdEventsCount,
      'joinedEventIds': instance.joinedEventIds,
      'createdEventIds': instance.createdEventIds,
      'friendIds': instance.friendIds,
      'incomingFriendRequestIds': instance.incomingFriendRequestIds,
      'outgoingFriendRequestIds': instance.outgoingFriendRequestIds,
      'blockedUserIds': instance.blockedUserIds,
      'lastSeenAt': _$JsonConverterToJson<dynamic, DateTime>(
        instance.lastSeenAt,
        const TimestampConverter().toJson,
      ),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
