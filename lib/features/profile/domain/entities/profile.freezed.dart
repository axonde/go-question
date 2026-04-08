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
  String get email => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  DateTime? get birthDate => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  int get trophies => throw _privateConstructorUsedError;
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
    String email,
    String name,
    String nickname,
    DateTime? birthDate,
    String? city,
    int trophies,
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
    Object? email = null,
    Object? name = null,
    Object? nickname = null,
    Object? birthDate = freezed,
    Object? city = freezed,
    Object? trophies = null,
    Object? visitedEventsCount = null,
    Object? createdEventsCount = null,
  }) {
    return _then(
      _value.copyWith(
            uid: null == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            nickname: null == nickname
                ? _value.nickname
                : nickname // ignore: cast_nullable_to_non_nullable
                      as String,
            birthDate: freezed == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            trophies: null == trophies
                ? _value.trophies
                : trophies // ignore: cast_nullable_to_non_nullable
                      as int,
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
    String email,
    String name,
    String nickname,
    DateTime? birthDate,
    String? city,
    int trophies,
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
    Object? email = null,
    Object? name = null,
    Object? nickname = null,
    Object? birthDate = freezed,
    Object? city = freezed,
    Object? trophies = null,
    Object? visitedEventsCount = null,
    Object? createdEventsCount = null,
  }) {
    return _then(
      _$ProfileImpl(
        uid: null == uid
            ? _value.uid
            : uid // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        nickname: null == nickname
            ? _value.nickname
            : nickname // ignore: cast_nullable_to_non_nullable
                  as String,
        birthDate: freezed == birthDate
            ? _value.birthDate
            : birthDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        trophies: null == trophies
            ? _value.trophies
            : trophies // ignore: cast_nullable_to_non_nullable
                  as int,
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
    required this.email,
    required this.name,
    required this.nickname,
    this.birthDate,
    this.city,
    this.trophies = 0,
    this.visitedEventsCount = 0,
    this.createdEventsCount = 0,
  }) : super._();

  @override
  final String uid;
  @override
  final String email;
  @override
  final String name;
  @override
  final String nickname;
  @override
  final DateTime? birthDate;
  @override
  final String? city;
  @override
  @JsonKey()
  final int trophies;
  @override
  @JsonKey()
  final int visitedEventsCount;
  @override
  @JsonKey()
  final int createdEventsCount;

  @override
  String toString() {
    return 'Profile(uid: $uid, email: $email, name: $name, nickname: $nickname, birthDate: $birthDate, city: $city, trophies: $trophies, visitedEventsCount: $visitedEventsCount, createdEventsCount: $createdEventsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.trophies, trophies) ||
                other.trophies == trophies) &&
            (identical(other.visitedEventsCount, visitedEventsCount) ||
                other.visitedEventsCount == visitedEventsCount) &&
            (identical(other.createdEventsCount, createdEventsCount) ||
                other.createdEventsCount == createdEventsCount));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    uid,
    email,
    name,
    nickname,
    birthDate,
    city,
    trophies,
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
    required final String email,
    required final String name,
    required final String nickname,
    final DateTime? birthDate,
    final String? city,
    final int trophies,
    final int visitedEventsCount,
    final int createdEventsCount,
  }) = _$ProfileImpl;
  const _Profile._() : super._();

  @override
  String get uid;
  @override
  String get email;
  @override
  String get name;
  @override
  String get nickname;
  @override
  DateTime? get birthDate;
  @override
  String? get city;
  @override
  int get trophies;
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
