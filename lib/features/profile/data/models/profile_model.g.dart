// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileModelImpl _$$ProfileModelImplFromJson(Map<String, dynamic> json) =>
    _$ProfileModelImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      nickname: json['nickname'] as String,
      birthDate: const TimestampConverter().fromJson(json['birthDate']),
      city: json['city'] as String?,
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
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$ProfileModelImplToJson(_$ProfileModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'name': instance.name,
      'nickname': instance.nickname,
      'birthDate': _$JsonConverterToJson<dynamic, DateTime>(
        instance.birthDate,
        const TimestampConverter().toJson,
      ),
      'city': instance.city,
      'trophies': instance.trophies,
      'visitedEventsCount': instance.visitedEventsCount,
      'createdEventsCount': instance.createdEventsCount,
      'joinedEventIds': instance.joinedEventIds,
      'createdEventIds': instance.createdEventIds,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
