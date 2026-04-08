// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileModelImpl _$$ProfileModelImplFromJson(Map<String, dynamic> json) =>
    _$ProfileModelImpl(
      uid: json['uid'] as String,
      name: json['name'] as String,
      age: (json['age'] as num?)?.toInt(),
      visitedEventsCount: (json['visitedEventsCount'] as num?)?.toInt() ?? 0,
      createdEventsCount: (json['createdEventsCount'] as num?)?.toInt() ?? 0,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$ProfileModelImplToJson(_$ProfileModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'age': instance.age,
      'visitedEventsCount': instance.visitedEventsCount,
      'createdEventsCount': instance.createdEventsCount,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
