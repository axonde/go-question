// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EventEntity _$EventEntityFromJson(Map<String, dynamic> json) {
  return _EventEntity.fromJson(json);
}

/// @nodoc
mixin _$EventEntity {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get startTime => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get maxUsers => throw _privateConstructorUsedError;
  int get participants => throw _privateConstructorUsedError;
  String get organizer => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this EventEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventEntityCopyWith<EventEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventEntityCopyWith<$Res> {
  factory $EventEntityCopyWith(
    EventEntity value,
    $Res Function(EventEntity) then,
  ) = _$EventEntityCopyWithImpl<$Res, EventEntity>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String imageUrl,
    @TimestampConverter() DateTime startTime,
    String location,
    String category,
    double price,
    int maxUsers,
    int participants,
    String organizer,
    String status,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
  });
}

/// @nodoc
class _$EventEntityCopyWithImpl<$Res, $Val extends EventEntity>
    implements $EventEntityCopyWith<$Res> {
  _$EventEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? startTime = null,
    Object? location = null,
    Object? category = null,
    Object? price = null,
    Object? maxUsers = null,
    Object? participants = null,
    Object? organizer = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            maxUsers: null == maxUsers
                ? _value.maxUsers
                : maxUsers // ignore: cast_nullable_to_non_nullable
                      as int,
            participants: null == participants
                ? _value.participants
                : participants // ignore: cast_nullable_to_non_nullable
                      as int,
            organizer: null == organizer
                ? _value.organizer
                : organizer // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EventEntityImplCopyWith<$Res>
    implements $EventEntityCopyWith<$Res> {
  factory _$$EventEntityImplCopyWith(
    _$EventEntityImpl value,
    $Res Function(_$EventEntityImpl) then,
  ) = __$$EventEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String imageUrl,
    @TimestampConverter() DateTime startTime,
    String location,
    String category,
    double price,
    int maxUsers,
    int participants,
    String organizer,
    String status,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
  });
}

/// @nodoc
class __$$EventEntityImplCopyWithImpl<$Res>
    extends _$EventEntityCopyWithImpl<$Res, _$EventEntityImpl>
    implements _$$EventEntityImplCopyWith<$Res> {
  __$$EventEntityImplCopyWithImpl(
    _$EventEntityImpl _value,
    $Res Function(_$EventEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? startTime = null,
    Object? location = null,
    Object? category = null,
    Object? price = null,
    Object? maxUsers = null,
    Object? participants = null,
    Object? organizer = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$EventEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        maxUsers: null == maxUsers
            ? _value.maxUsers
            : maxUsers // ignore: cast_nullable_to_non_nullable
                  as int,
        participants: null == participants
            ? _value.participants
            : participants // ignore: cast_nullable_to_non_nullable
                  as int,
        organizer: null == organizer
            ? _value.organizer
            : organizer // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EventEntityImpl implements _EventEntity {
  const _$EventEntityImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    @TimestampConverter() required this.startTime,
    required this.location,
    required this.category,
    required this.price,
    required this.maxUsers,
    required this.participants,
    required this.organizer,
    required this.status,
    @TimestampConverter() required this.createdAt,
    @TimestampConverter() required this.updatedAt,
  });

  factory _$EventEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String imageUrl;
  @override
  @TimestampConverter()
  final DateTime startTime;
  @override
  final String location;
  @override
  final String category;
  @override
  final double price;
  @override
  final int maxUsers;
  @override
  final int participants;
  @override
  final String organizer;
  @override
  final String status;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;

  @override
  String toString() {
    return 'EventEntity(id: $id, title: $title, description: $description, imageUrl: $imageUrl, startTime: $startTime, location: $location, category: $category, price: $price, maxUsers: $maxUsers, participants: $participants, organizer: $organizer, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.maxUsers, maxUsers) ||
                other.maxUsers == maxUsers) &&
            (identical(other.participants, participants) ||
                other.participants == participants) &&
            (identical(other.organizer, organizer) ||
                other.organizer == organizer) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    imageUrl,
    startTime,
    location,
    category,
    price,
    maxUsers,
    participants,
    organizer,
    status,
    createdAt,
    updatedAt,
  );

  /// Create a copy of EventEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventEntityImplCopyWith<_$EventEntityImpl> get copyWith =>
      __$$EventEntityImplCopyWithImpl<_$EventEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventEntityImplToJson(this);
  }
}

abstract class _EventEntity implements EventEntity {
  const factory _EventEntity({
    required final String id,
    required final String title,
    required final String description,
    required final String imageUrl,
    @TimestampConverter() required final DateTime startTime,
    required final String location,
    required final String category,
    required final double price,
    required final int maxUsers,
    required final int participants,
    required final String organizer,
    required final String status,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampConverter() required final DateTime updatedAt,
  }) = _$EventEntityImpl;

  factory _EventEntity.fromJson(Map<String, dynamic> json) =
      _$EventEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get imageUrl;
  @override
  @TimestampConverter()
  DateTime get startTime;
  @override
  String get location;
  @override
  String get category;
  @override
  double get price;
  @override
  int get maxUsers;
  @override
  int get participants;
  @override
  String get organizer;
  @override
  String get status;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;

  /// Create a copy of EventEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventEntityImplCopyWith<_$EventEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
