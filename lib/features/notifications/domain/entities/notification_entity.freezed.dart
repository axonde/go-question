// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationEntity _$NotificationEntityFromJson(Map<String, dynamic> json) {
  return _NotificationEntity.fromJson(json);
}

/// @nodoc
mixin _$NotificationEntity {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  NotificationType get type => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError; // Опциональные поля для запросов на участие
  String? get requestUserId => throw _privateConstructorUsedError;
  String? get requestUserName => throw _privateConstructorUsedError;
  String? get requestUserRating => throw _privateConstructorUsedError;
  String? get requestUserAge => throw _privateConstructorUsedError;
  String? get requestUserGender => throw _privateConstructorUsedError;
  String? get requestUserCity => throw _privateConstructorUsedError;
  String? get requestUserBio => throw _privateConstructorUsedError;
  int? get requestUserEventsAttended => throw _privateConstructorUsedError;
  int? get requestUserEventsOrganized =>
      throw _privateConstructorUsedError; // Опциональные поля для событий
  String? get eventId => throw _privateConstructorUsedError;
  String? get eventTitle => throw _privateConstructorUsedError;
  String? get eventDate => throw _privateConstructorUsedError;
  String? get eventLocation => throw _privateConstructorUsedError;
  String? get eventCategory => throw _privateConstructorUsedError;

  /// Serializes this NotificationEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationEntityCopyWith<NotificationEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationEntityCopyWith<$Res> {
  factory $NotificationEntityCopyWith(
    NotificationEntity value,
    $Res Function(NotificationEntity) then,
  ) = _$NotificationEntityCopyWithImpl<$Res, NotificationEntity>;
  @useResult
  $Res call({
    String id,
    String userId,
    String title,
    String body,
    NotificationType type,
    bool isRead,
    @TimestampConverter() DateTime createdAt,
    String? requestUserId,
    String? requestUserName,
    String? requestUserRating,
    String? requestUserAge,
    String? requestUserGender,
    String? requestUserCity,
    String? requestUserBio,
    int? requestUserEventsAttended,
    int? requestUserEventsOrganized,
    String? eventId,
    String? eventTitle,
    String? eventDate,
    String? eventLocation,
    String? eventCategory,
  });
}

/// @nodoc
class _$NotificationEntityCopyWithImpl<$Res, $Val extends NotificationEntity>
    implements $NotificationEntityCopyWith<$Res> {
  _$NotificationEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? body = null,
    Object? type = null,
    Object? isRead = null,
    Object? createdAt = null,
    Object? requestUserId = freezed,
    Object? requestUserName = freezed,
    Object? requestUserRating = freezed,
    Object? requestUserAge = freezed,
    Object? requestUserGender = freezed,
    Object? requestUserCity = freezed,
    Object? requestUserBio = freezed,
    Object? requestUserEventsAttended = freezed,
    Object? requestUserEventsOrganized = freezed,
    Object? eventId = freezed,
    Object? eventTitle = freezed,
    Object? eventDate = freezed,
    Object? eventLocation = freezed,
    Object? eventCategory = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as NotificationType,
            isRead: null == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            requestUserId: freezed == requestUserId
                ? _value.requestUserId
                : requestUserId // ignore: cast_nullable_to_non_nullable
                      as String?,
            requestUserName: freezed == requestUserName
                ? _value.requestUserName
                : requestUserName // ignore: cast_nullable_to_non_nullable
                      as String?,
            requestUserRating: freezed == requestUserRating
                ? _value.requestUserRating
                : requestUserRating // ignore: cast_nullable_to_non_nullable
                      as String?,
            requestUserAge: freezed == requestUserAge
                ? _value.requestUserAge
                : requestUserAge // ignore: cast_nullable_to_non_nullable
                      as String?,
            requestUserGender: freezed == requestUserGender
                ? _value.requestUserGender
                : requestUserGender // ignore: cast_nullable_to_non_nullable
                      as String?,
            requestUserCity: freezed == requestUserCity
                ? _value.requestUserCity
                : requestUserCity // ignore: cast_nullable_to_non_nullable
                      as String?,
            requestUserBio: freezed == requestUserBio
                ? _value.requestUserBio
                : requestUserBio // ignore: cast_nullable_to_non_nullable
                      as String?,
            requestUserEventsAttended: freezed == requestUserEventsAttended
                ? _value.requestUserEventsAttended
                : requestUserEventsAttended // ignore: cast_nullable_to_non_nullable
                      as int?,
            requestUserEventsOrganized: freezed == requestUserEventsOrganized
                ? _value.requestUserEventsOrganized
                : requestUserEventsOrganized // ignore: cast_nullable_to_non_nullable
                      as int?,
            eventId: freezed == eventId
                ? _value.eventId
                : eventId // ignore: cast_nullable_to_non_nullable
                      as String?,
            eventTitle: freezed == eventTitle
                ? _value.eventTitle
                : eventTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            eventDate: freezed == eventDate
                ? _value.eventDate
                : eventDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            eventLocation: freezed == eventLocation
                ? _value.eventLocation
                : eventLocation // ignore: cast_nullable_to_non_nullable
                      as String?,
            eventCategory: freezed == eventCategory
                ? _value.eventCategory
                : eventCategory // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationEntityImplCopyWith<$Res>
    implements $NotificationEntityCopyWith<$Res> {
  factory _$$NotificationEntityImplCopyWith(
    _$NotificationEntityImpl value,
    $Res Function(_$NotificationEntityImpl) then,
  ) = __$$NotificationEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String title,
    String body,
    NotificationType type,
    bool isRead,
    @TimestampConverter() DateTime createdAt,
    String? requestUserId,
    String? requestUserName,
    String? requestUserRating,
    String? requestUserAge,
    String? requestUserGender,
    String? requestUserCity,
    String? requestUserBio,
    int? requestUserEventsAttended,
    int? requestUserEventsOrganized,
    String? eventId,
    String? eventTitle,
    String? eventDate,
    String? eventLocation,
    String? eventCategory,
  });
}

/// @nodoc
class __$$NotificationEntityImplCopyWithImpl<$Res>
    extends _$NotificationEntityCopyWithImpl<$Res, _$NotificationEntityImpl>
    implements _$$NotificationEntityImplCopyWith<$Res> {
  __$$NotificationEntityImplCopyWithImpl(
    _$NotificationEntityImpl _value,
    $Res Function(_$NotificationEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? body = null,
    Object? type = null,
    Object? isRead = null,
    Object? createdAt = null,
    Object? requestUserId = freezed,
    Object? requestUserName = freezed,
    Object? requestUserRating = freezed,
    Object? requestUserAge = freezed,
    Object? requestUserGender = freezed,
    Object? requestUserCity = freezed,
    Object? requestUserBio = freezed,
    Object? requestUserEventsAttended = freezed,
    Object? requestUserEventsOrganized = freezed,
    Object? eventId = freezed,
    Object? eventTitle = freezed,
    Object? eventDate = freezed,
    Object? eventLocation = freezed,
    Object? eventCategory = freezed,
  }) {
    return _then(
      _$NotificationEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as NotificationType,
        isRead: null == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        requestUserId: freezed == requestUserId
            ? _value.requestUserId
            : requestUserId // ignore: cast_nullable_to_non_nullable
                  as String?,
        requestUserName: freezed == requestUserName
            ? _value.requestUserName
            : requestUserName // ignore: cast_nullable_to_non_nullable
                  as String?,
        requestUserRating: freezed == requestUserRating
            ? _value.requestUserRating
            : requestUserRating // ignore: cast_nullable_to_non_nullable
                  as String?,
        requestUserAge: freezed == requestUserAge
            ? _value.requestUserAge
            : requestUserAge // ignore: cast_nullable_to_non_nullable
                  as String?,
        requestUserGender: freezed == requestUserGender
            ? _value.requestUserGender
            : requestUserGender // ignore: cast_nullable_to_non_nullable
                  as String?,
        requestUserCity: freezed == requestUserCity
            ? _value.requestUserCity
            : requestUserCity // ignore: cast_nullable_to_non_nullable
                  as String?,
        requestUserBio: freezed == requestUserBio
            ? _value.requestUserBio
            : requestUserBio // ignore: cast_nullable_to_non_nullable
                  as String?,
        requestUserEventsAttended: freezed == requestUserEventsAttended
            ? _value.requestUserEventsAttended
            : requestUserEventsAttended // ignore: cast_nullable_to_non_nullable
                  as int?,
        requestUserEventsOrganized: freezed == requestUserEventsOrganized
            ? _value.requestUserEventsOrganized
            : requestUserEventsOrganized // ignore: cast_nullable_to_non_nullable
                  as int?,
        eventId: freezed == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as String?,
        eventTitle: freezed == eventTitle
            ? _value.eventTitle
            : eventTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        eventDate: freezed == eventDate
            ? _value.eventDate
            : eventDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        eventLocation: freezed == eventLocation
            ? _value.eventLocation
            : eventLocation // ignore: cast_nullable_to_non_nullable
                  as String?,
        eventCategory: freezed == eventCategory
            ? _value.eventCategory
            : eventCategory // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationEntityImpl implements _NotificationEntity {
  const _$NotificationEntityImpl({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    @TimestampConverter() required this.createdAt,
    this.requestUserId,
    this.requestUserName,
    this.requestUserRating,
    this.requestUserAge,
    this.requestUserGender,
    this.requestUserCity,
    this.requestUserBio,
    this.requestUserEventsAttended,
    this.requestUserEventsOrganized,
    this.eventId,
    this.eventTitle,
    this.eventDate,
    this.eventLocation,
    this.eventCategory,
  });

  factory _$NotificationEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String title;
  @override
  final String body;
  @override
  final NotificationType type;
  @override
  final bool isRead;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  // Опциональные поля для запросов на участие
  @override
  final String? requestUserId;
  @override
  final String? requestUserName;
  @override
  final String? requestUserRating;
  @override
  final String? requestUserAge;
  @override
  final String? requestUserGender;
  @override
  final String? requestUserCity;
  @override
  final String? requestUserBio;
  @override
  final int? requestUserEventsAttended;
  @override
  final int? requestUserEventsOrganized;
  // Опциональные поля для событий
  @override
  final String? eventId;
  @override
  final String? eventTitle;
  @override
  final String? eventDate;
  @override
  final String? eventLocation;
  @override
  final String? eventCategory;

  @override
  String toString() {
    return 'NotificationEntity(id: $id, userId: $userId, title: $title, body: $body, type: $type, isRead: $isRead, createdAt: $createdAt, requestUserId: $requestUserId, requestUserName: $requestUserName, requestUserRating: $requestUserRating, requestUserAge: $requestUserAge, requestUserGender: $requestUserGender, requestUserCity: $requestUserCity, requestUserBio: $requestUserBio, requestUserEventsAttended: $requestUserEventsAttended, requestUserEventsOrganized: $requestUserEventsOrganized, eventId: $eventId, eventTitle: $eventTitle, eventDate: $eventDate, eventLocation: $eventLocation, eventCategory: $eventCategory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.requestUserId, requestUserId) ||
                other.requestUserId == requestUserId) &&
            (identical(other.requestUserName, requestUserName) ||
                other.requestUserName == requestUserName) &&
            (identical(other.requestUserRating, requestUserRating) ||
                other.requestUserRating == requestUserRating) &&
            (identical(other.requestUserAge, requestUserAge) ||
                other.requestUserAge == requestUserAge) &&
            (identical(other.requestUserGender, requestUserGender) ||
                other.requestUserGender == requestUserGender) &&
            (identical(other.requestUserCity, requestUserCity) ||
                other.requestUserCity == requestUserCity) &&
            (identical(other.requestUserBio, requestUserBio) ||
                other.requestUserBio == requestUserBio) &&
            (identical(
                  other.requestUserEventsAttended,
                  requestUserEventsAttended,
                ) ||
                other.requestUserEventsAttended == requestUserEventsAttended) &&
            (identical(
                  other.requestUserEventsOrganized,
                  requestUserEventsOrganized,
                ) ||
                other.requestUserEventsOrganized ==
                    requestUserEventsOrganized) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventTitle, eventTitle) ||
                other.eventTitle == eventTitle) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.eventLocation, eventLocation) ||
                other.eventLocation == eventLocation) &&
            (identical(other.eventCategory, eventCategory) ||
                other.eventCategory == eventCategory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    userId,
    title,
    body,
    type,
    isRead,
    createdAt,
    requestUserId,
    requestUserName,
    requestUserRating,
    requestUserAge,
    requestUserGender,
    requestUserCity,
    requestUserBio,
    requestUserEventsAttended,
    requestUserEventsOrganized,
    eventId,
    eventTitle,
    eventDate,
    eventLocation,
    eventCategory,
  ]);

  /// Create a copy of NotificationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationEntityImplCopyWith<_$NotificationEntityImpl> get copyWith =>
      __$$NotificationEntityImplCopyWithImpl<_$NotificationEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationEntityImplToJson(this);
  }
}

abstract class _NotificationEntity implements NotificationEntity {
  const factory _NotificationEntity({
    required final String id,
    required final String userId,
    required final String title,
    required final String body,
    required final NotificationType type,
    required final bool isRead,
    @TimestampConverter() required final DateTime createdAt,
    final String? requestUserId,
    final String? requestUserName,
    final String? requestUserRating,
    final String? requestUserAge,
    final String? requestUserGender,
    final String? requestUserCity,
    final String? requestUserBio,
    final int? requestUserEventsAttended,
    final int? requestUserEventsOrganized,
    final String? eventId,
    final String? eventTitle,
    final String? eventDate,
    final String? eventLocation,
    final String? eventCategory,
  }) = _$NotificationEntityImpl;

  factory _NotificationEntity.fromJson(Map<String, dynamic> json) =
      _$NotificationEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get title;
  @override
  String get body;
  @override
  NotificationType get type;
  @override
  bool get isRead;
  @override
  @TimestampConverter()
  DateTime get createdAt; // Опциональные поля для запросов на участие
  @override
  String? get requestUserId;
  @override
  String? get requestUserName;
  @override
  String? get requestUserRating;
  @override
  String? get requestUserAge;
  @override
  String? get requestUserGender;
  @override
  String? get requestUserCity;
  @override
  String? get requestUserBio;
  @override
  int? get requestUserEventsAttended;
  @override
  int? get requestUserEventsOrganized; // Опциональные поля для событий
  @override
  String? get eventId;
  @override
  String? get eventTitle;
  @override
  String? get eventDate;
  @override
  String? get eventLocation;
  @override
  String? get eventCategory;

  /// Create a copy of NotificationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationEntityImplCopyWith<_$NotificationEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
