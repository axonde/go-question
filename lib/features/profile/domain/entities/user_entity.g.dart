// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserEntityImpl _$$UserEntityImplFromJson(Map<String, dynamic> json) =>
    _$UserEntityImpl(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      nickname: json['nickname'] as String,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      city: json['city'] as String?,
      bio: json['bio'] as String?,
      interests:
          (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      socialLinks:
          (json['socialLinks'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      trophies: (json['trophies'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserEntityImplToJson(_$UserEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'nickname': instance.nickname,
      'birthDate': instance.birthDate?.toIso8601String(),
      'city': instance.city,
      'bio': instance.bio,
      'interests': instance.interests,
      'socialLinks': instance.socialLinks,
      'email': instance.email,
      'avatarUrl': instance.avatarUrl,
      'trophies': instance.trophies,
    };
