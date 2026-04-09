// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventEntityImpl _$$EventEntityImplFromJson(Map<String, dynamic> json) =>
    _$EventEntityImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startTime: const TimestampConverter().fromJson(json['startTime']),
      location: json['location'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      maxUsers: (json['maxUsers'] as num).toInt(),
      participants: (json['participants'] as num).toInt(),
      organizer: json['organizer'] as String,
      status: json['status'] as String,
      imageUrl: json['imageUrl'] as String?,
      participantIds:
          (json['participantIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      pendingParticipantIds:
          (json['pendingParticipantIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      rejectedParticipantIds:
          (json['rejectedParticipantIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      requiresApproval: json['requiresApproval'] as bool? ?? false,
      visibility: json['visibility'] as String? ?? 'public',
      joinMode: json['joinMode'] as String? ?? 'open',
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$EventEntityImplToJson(_$EventEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'startTime': const TimestampConverter().toJson(instance.startTime),
      'location': instance.location,
      'category': instance.category,
      'price': instance.price,
      'maxUsers': instance.maxUsers,
      'participants': instance.participants,
      'organizer': instance.organizer,
      'status': instance.status,
      'imageUrl': instance.imageUrl,
      'participantIds': instance.participantIds,
      'pendingParticipantIds': instance.pendingParticipantIds,
      'rejectedParticipantIds': instance.rejectedParticipantIds,
      'requiresApproval': instance.requiresApproval,
      'visibility': instance.visibility,
      'joinMode': instance.joinMode,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
