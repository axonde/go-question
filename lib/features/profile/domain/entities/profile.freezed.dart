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
  String? get bio => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  int? get age => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get trophies => throw _privateConstructorUsedError;
  int get visitedEventsCount => throw _privateConstructorUsedError;
  int get createdEventsCount => throw _privateConstructorUsedError;
  List<String> get joinedEventIds => throw _privateConstructorUsedError;
  List<String> get createdEventIds => throw _privateConstructorUsedError;
  List<String> get friendIds => throw _privateConstructorUsedError;
  List<String> get incomingFriendRequestIds =>
      throw _privateConstructorUsedError;
  List<String> get outgoingFriendRequestIds =>
      throw _privateConstructorUsedError;
  List<String> get blockedUserIds => throw _privateConstructorUsedError;
  DateTime? get lastSeenAt => throw _privateConstructorUsedError;

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
    String? bio,
    String? avatarUrl,
    String? gender,
    int? age,
    double rating,
    int trophies,
    int visitedEventsCount,
    int createdEventsCount,
    List<String> joinedEventIds,
    List<String> createdEventIds,
    List<String> friendIds,
    List<String> incomingFriendRequestIds,
    List<String> outgoingFriendRequestIds,
    List<String> blockedUserIds,
    DateTime? lastSeenAt,
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
    Object? bio = freezed,
    Object? avatarUrl = freezed,
    Object? gender = freezed,
    Object? age = freezed,
    Object? rating = null,
    Object? trophies = null,
    Object? visitedEventsCount = null,
    Object? createdEventsCount = null,
    Object? joinedEventIds = null,
    Object? createdEventIds = null,
    Object? friendIds = null,
    Object? incomingFriendRequestIds = null,
    Object? outgoingFriendRequestIds = null,
    Object? blockedUserIds = null,
    Object? lastSeenAt = freezed,
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
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String?,
            age: freezed == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                      as int?,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
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
            joinedEventIds: null == joinedEventIds
                ? _value.joinedEventIds
                : joinedEventIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdEventIds: null == createdEventIds
                ? _value.createdEventIds
                : createdEventIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            friendIds: null == friendIds
                ? _value.friendIds
                : friendIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            incomingFriendRequestIds: null == incomingFriendRequestIds
                ? _value.incomingFriendRequestIds
                : incomingFriendRequestIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            outgoingFriendRequestIds: null == outgoingFriendRequestIds
                ? _value.outgoingFriendRequestIds
                : outgoingFriendRequestIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            blockedUserIds: null == blockedUserIds
                ? _value.blockedUserIds
                : blockedUserIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            lastSeenAt: freezed == lastSeenAt
                ? _value.lastSeenAt
                : lastSeenAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
    String? bio,
    String? avatarUrl,
    String? gender,
    int? age,
    double rating,
    int trophies,
    int visitedEventsCount,
    int createdEventsCount,
    List<String> joinedEventIds,
    List<String> createdEventIds,
    List<String> friendIds,
    List<String> incomingFriendRequestIds,
    List<String> outgoingFriendRequestIds,
    List<String> blockedUserIds,
    DateTime? lastSeenAt,
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
    Object? bio = freezed,
    Object? avatarUrl = freezed,
    Object? gender = freezed,
    Object? age = freezed,
    Object? rating = null,
    Object? trophies = null,
    Object? visitedEventsCount = null,
    Object? createdEventsCount = null,
    Object? joinedEventIds = null,
    Object? createdEventIds = null,
    Object? friendIds = null,
    Object? incomingFriendRequestIds = null,
    Object? outgoingFriendRequestIds = null,
    Object? blockedUserIds = null,
    Object? lastSeenAt = freezed,
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
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String?,
        age: freezed == age
            ? _value.age
            : age // ignore: cast_nullable_to_non_nullable
                  as int?,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
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
        joinedEventIds: null == joinedEventIds
            ? _value._joinedEventIds
            : joinedEventIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdEventIds: null == createdEventIds
            ? _value._createdEventIds
            : createdEventIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        friendIds: null == friendIds
            ? _value._friendIds
            : friendIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        incomingFriendRequestIds: null == incomingFriendRequestIds
            ? _value._incomingFriendRequestIds
            : incomingFriendRequestIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        outgoingFriendRequestIds: null == outgoingFriendRequestIds
            ? _value._outgoingFriendRequestIds
            : outgoingFriendRequestIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        blockedUserIds: null == blockedUserIds
            ? _value._blockedUserIds
            : blockedUserIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        lastSeenAt: freezed == lastSeenAt
            ? _value.lastSeenAt
            : lastSeenAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
    this.bio,
    this.avatarUrl,
    this.gender,
    this.age,
    this.rating = 0.0,
    this.trophies = 0,
    this.visitedEventsCount = 0,
    this.createdEventsCount = 0,
    final List<String> joinedEventIds = const <String>[],
    final List<String> createdEventIds = const <String>[],
    final List<String> friendIds = const <String>[],
    final List<String> incomingFriendRequestIds = const <String>[],
    final List<String> outgoingFriendRequestIds = const <String>[],
    final List<String> blockedUserIds = const <String>[],
    this.lastSeenAt,
  }) : _joinedEventIds = joinedEventIds,
       _createdEventIds = createdEventIds,
       _friendIds = friendIds,
       _incomingFriendRequestIds = incomingFriendRequestIds,
       _outgoingFriendRequestIds = outgoingFriendRequestIds,
       _blockedUserIds = blockedUserIds,
       super._();

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
  final String? bio;
  @override
  final String? avatarUrl;
  @override
  final String? gender;
  @override
  final int? age;
  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int trophies;
  @override
  @JsonKey()
  final int visitedEventsCount;
  @override
  @JsonKey()
  final int createdEventsCount;
  final List<String> _joinedEventIds;
  @override
  @JsonKey()
  List<String> get joinedEventIds {
    if (_joinedEventIds is EqualUnmodifiableListView) return _joinedEventIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_joinedEventIds);
  }

  final List<String> _createdEventIds;
  @override
  @JsonKey()
  List<String> get createdEventIds {
    if (_createdEventIds is EqualUnmodifiableListView) return _createdEventIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_createdEventIds);
  }

  final List<String> _friendIds;
  @override
  @JsonKey()
  List<String> get friendIds {
    if (_friendIds is EqualUnmodifiableListView) return _friendIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friendIds);
  }

  final List<String> _incomingFriendRequestIds;
  @override
  @JsonKey()
  List<String> get incomingFriendRequestIds {
    if (_incomingFriendRequestIds is EqualUnmodifiableListView)
      return _incomingFriendRequestIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_incomingFriendRequestIds);
  }

  final List<String> _outgoingFriendRequestIds;
  @override
  @JsonKey()
  List<String> get outgoingFriendRequestIds {
    if (_outgoingFriendRequestIds is EqualUnmodifiableListView)
      return _outgoingFriendRequestIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_outgoingFriendRequestIds);
  }

  final List<String> _blockedUserIds;
  @override
  @JsonKey()
  List<String> get blockedUserIds {
    if (_blockedUserIds is EqualUnmodifiableListView) return _blockedUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blockedUserIds);
  }

  @override
  final DateTime? lastSeenAt;

  @override
  String toString() {
    return 'Profile(uid: $uid, email: $email, name: $name, nickname: $nickname, birthDate: $birthDate, city: $city, bio: $bio, avatarUrl: $avatarUrl, gender: $gender, age: $age, rating: $rating, trophies: $trophies, visitedEventsCount: $visitedEventsCount, createdEventsCount: $createdEventsCount, joinedEventIds: $joinedEventIds, createdEventIds: $createdEventIds, friendIds: $friendIds, incomingFriendRequestIds: $incomingFriendRequestIds, outgoingFriendRequestIds: $outgoingFriendRequestIds, blockedUserIds: $blockedUserIds, lastSeenAt: $lastSeenAt)';
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
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.trophies, trophies) ||
                other.trophies == trophies) &&
            (identical(other.visitedEventsCount, visitedEventsCount) ||
                other.visitedEventsCount == visitedEventsCount) &&
            (identical(other.createdEventsCount, createdEventsCount) ||
                other.createdEventsCount == createdEventsCount) &&
            const DeepCollectionEquality().equals(
              other._joinedEventIds,
              _joinedEventIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._createdEventIds,
              _createdEventIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._friendIds,
              _friendIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._incomingFriendRequestIds,
              _incomingFriendRequestIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._outgoingFriendRequestIds,
              _outgoingFriendRequestIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._blockedUserIds,
              _blockedUserIds,
            ) &&
            (identical(other.lastSeenAt, lastSeenAt) ||
                other.lastSeenAt == lastSeenAt));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    uid,
    email,
    name,
    nickname,
    birthDate,
    city,
    bio,
    avatarUrl,
    gender,
    age,
    rating,
    trophies,
    visitedEventsCount,
    createdEventsCount,
    const DeepCollectionEquality().hash(_joinedEventIds),
    const DeepCollectionEquality().hash(_createdEventIds),
    const DeepCollectionEquality().hash(_friendIds),
    const DeepCollectionEquality().hash(_incomingFriendRequestIds),
    const DeepCollectionEquality().hash(_outgoingFriendRequestIds),
    const DeepCollectionEquality().hash(_blockedUserIds),
    lastSeenAt,
  ]);

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
    final String? bio,
    final String? avatarUrl,
    final String? gender,
    final int? age,
    final double rating,
    final int trophies,
    final int visitedEventsCount,
    final int createdEventsCount,
    final List<String> joinedEventIds,
    final List<String> createdEventIds,
    final List<String> friendIds,
    final List<String> incomingFriendRequestIds,
    final List<String> outgoingFriendRequestIds,
    final List<String> blockedUserIds,
    final DateTime? lastSeenAt,
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
  String? get bio;
  @override
  String? get avatarUrl;
  @override
  String? get gender;
  @override
  int? get age;
  @override
  double get rating;
  @override
  int get trophies;
  @override
  int get visitedEventsCount;
  @override
  int get createdEventsCount;
  @override
  List<String> get joinedEventIds;
  @override
  List<String> get createdEventIds;
  @override
  List<String> get friendIds;
  @override
  List<String> get incomingFriendRequestIds;
  @override
  List<String> get outgoingFriendRequestIds;
  @override
  List<String> get blockedUserIds;
  @override
  DateTime? get lastSeenAt;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileImplCopyWith<_$ProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
