// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Profile {
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int? get age => throw _privateConstructorUsedError;
  int get visitedEventsCount => throw _privateConstructorUsedError;
  int get createdEventsCount => throw _privateConstructorUsedError;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileCopyWith<Profile> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileCopyWith<$Res> {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) then) =
      _$ProfileCopyWithImpl<$Res, Profile>;
  @useResult
  $Res call({
    String uid,
    String name,
    int? age,
    int visitedEventsCount,
    int createdEventsCount,
  });
}

/// @nodoc
class _$ProfileCopyWithImpl<$Res, $Val extends Profile>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? age = freezed,
    Object? visitedEventsCount = null,
    Object? createdEventsCount = null,
  }) {
    return _then(
      _value.copyWith(
            uid: null == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            age: freezed == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                      as int?,
            visitedEventsCount: null == visitedEventsCount
                ? _value.visitedEventsCount
                : visitedEventsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            createdEventsCount: null == createdEventsCount
                ? _value.createdEventsCount
                : createdEventsCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProfileImplCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$$ProfileImplCopyWith(
    _$ProfileImpl value,
    $Res Function(_$ProfileImpl) then,
  ) = __$$ProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String uid,
    String name,
    int? age,
    int visitedEventsCount,
    int createdEventsCount,
  });
}

/// @nodoc
class __$$ProfileImplCopyWithImpl<$Res>
    extends _$ProfileCopyWithImpl<$Res, _$ProfileImpl>
    implements _$$ProfileImplCopyWith<$Res> {
  __$$ProfileImplCopyWithImpl(
    _$ProfileImpl _value,
    $Res Function(_$ProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? age = freezed,
    Object? visitedEventsCount = null,
    Object? createdEventsCount = null,
  }) {
    return _then(
      _$ProfileImpl(
        uid: null == uid
            ? _value.uid
            : uid // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        age: freezed == age
            ? _value.age
            : age // ignore: cast_nullable_to_non_nullable
                  as int?,
        visitedEventsCount: null == visitedEventsCount
            ? _value.visitedEventsCount
            : visitedEventsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        createdEventsCount: null == createdEventsCount
            ? _value.createdEventsCount
            : createdEventsCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$ProfileImpl extends _Profile {
  const _$ProfileImpl({
    required this.uid,
    required this.name,
    this.age,
    this.visitedEventsCount = 0,
    this.createdEventsCount = 0,
  }) : super._();

  @override
  final String uid;
  @override
  final String name;
  @override
  final int? age;
  @override
  @JsonKey()
  final int visitedEventsCount;
  @override
  @JsonKey()
  final int createdEventsCount;

  @override
  String toString() {
    return 'Profile(uid: $uid, name: $name, age: $age, visitedEventsCount: $visitedEventsCount, createdEventsCount: $createdEventsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.visitedEventsCount, visitedEventsCount) ||
                other.visitedEventsCount == visitedEventsCount) &&
            (identical(other.createdEventsCount, createdEventsCount) ||
                other.createdEventsCount == createdEventsCount));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    uid,
    name,
    age,
    visitedEventsCount,
    createdEventsCount,
  );

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileImplCopyWith<_$ProfileImpl> get copyWith =>
      __$$ProfileImplCopyWithImpl<_$ProfileImpl>(this, _$identity);
}

abstract class _Profile extends Profile {
  const factory _Profile({
    required final String uid,
    required final String name,
    final int? age,
    final int visitedEventsCount,
    final int createdEventsCount,
  }) = _$ProfileImpl;
  const _Profile._() : super._();

  @override
  String get uid;
  @override
  String get name;
  @override
  int? get age;
  @override
  int get visitedEventsCount;
  @override
  int get createdEventsCount;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileImplCopyWith<_$ProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
