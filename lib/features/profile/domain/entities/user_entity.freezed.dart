// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) {
  return _UserEntity.fromJson(json);
}

/// @nodoc
mixin _$UserEntity {
  String get id => throw _privateConstructorUsedError; // ID из Firebase Auth
  // Личная информация
  String get firstName => throw _privateConstructorUsedError; // Имя
  String get lastName => throw _privateConstructorUsedError; // Фамилия
  String get nickname =>
      throw _privateConstructorUsedError; // Никнейм (@max_maximov)
  DateTime? get birthDate =>
      throw _privateConstructorUsedError; // Дата рождения
  String? get city => throw _privateConstructorUsedError; // Город
  // Детали профиля (Bio, Интересы)
  String? get bio =>
      throw _privateConstructorUsedError; // Небольшое описание профиля
  List<String> get interests => throw _privateConstructorUsedError; // Интересы
  // Социальные сети
  // Ключ - название соцсети (например, 'vk', 'telegram', 'instagram'), Значение - ссылка
  Map<String, String> get socialLinks =>
      throw _privateConstructorUsedError; // Контакты
  String get email => throw _privateConstructorUsedError; // Email
  // Игровые/приложенческие статы
  String? get avatarUrl => throw _privateConstructorUsedError; // Ссылка на фото
  int get trophies => throw _privateConstructorUsedError;

  /// Serializes this UserEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserEntityCopyWith<UserEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserEntityCopyWith<$Res> {
  factory $UserEntityCopyWith(
    UserEntity value,
    $Res Function(UserEntity) then,
  ) = _$UserEntityCopyWithImpl<$Res, UserEntity>;
  @useResult
  $Res call({
    String id,
    String firstName,
    String lastName,
    String nickname,
    DateTime? birthDate,
    String? city,
    String? bio,
    List<String> interests,
    Map<String, String> socialLinks,
    String email,
    String? avatarUrl,
    int trophies,
  });
}

/// @nodoc
class _$UserEntityCopyWithImpl<$Res, $Val extends UserEntity>
    implements $UserEntityCopyWith<$Res> {
  _$UserEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? nickname = null,
    Object? birthDate = freezed,
    Object? city = freezed,
    Object? bio = freezed,
    Object? interests = null,
    Object? socialLinks = null,
    Object? email = null,
    Object? avatarUrl = freezed,
    Object? trophies = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
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
            interests: null == interests
                ? _value.interests
                : interests // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            socialLinks: null == socialLinks
                ? _value.socialLinks
                : socialLinks // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            trophies: null == trophies
                ? _value.trophies
                : trophies // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserEntityImplCopyWith<$Res>
    implements $UserEntityCopyWith<$Res> {
  factory _$$UserEntityImplCopyWith(
    _$UserEntityImpl value,
    $Res Function(_$UserEntityImpl) then,
  ) = __$$UserEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String firstName,
    String lastName,
    String nickname,
    DateTime? birthDate,
    String? city,
    String? bio,
    List<String> interests,
    Map<String, String> socialLinks,
    String email,
    String? avatarUrl,
    int trophies,
  });
}

/// @nodoc
class __$$UserEntityImplCopyWithImpl<$Res>
    extends _$UserEntityCopyWithImpl<$Res, _$UserEntityImpl>
    implements _$$UserEntityImplCopyWith<$Res> {
  __$$UserEntityImplCopyWithImpl(
    _$UserEntityImpl _value,
    $Res Function(_$UserEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? nickname = null,
    Object? birthDate = freezed,
    Object? city = freezed,
    Object? bio = freezed,
    Object? interests = null,
    Object? socialLinks = null,
    Object? email = null,
    Object? avatarUrl = freezed,
    Object? trophies = null,
  }) {
    return _then(
      _$UserEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: null == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
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
        interests: null == interests
            ? _value._interests
            : interests // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        socialLinks: null == socialLinks
            ? _value._socialLinks
            : socialLinks // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        trophies: null == trophies
            ? _value.trophies
            : trophies // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserEntityImpl extends _UserEntity {
  const _$UserEntityImpl({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    this.birthDate,
    this.city,
    this.bio,
    final List<String> interests = const [],
    final Map<String, String> socialLinks = const {},
    required this.email,
    this.avatarUrl,
    this.trophies = 0,
  }) : _interests = interests,
       _socialLinks = socialLinks,
       super._();

  factory _$UserEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserEntityImplFromJson(json);

  @override
  final String id;
  // ID из Firebase Auth
  // Личная информация
  @override
  final String firstName;
  // Имя
  @override
  final String lastName;
  // Фамилия
  @override
  final String nickname;
  // Никнейм (@max_maximov)
  @override
  final DateTime? birthDate;
  // Дата рождения
  @override
  final String? city;
  // Город
  // Детали профиля (Bio, Интересы)
  @override
  final String? bio;
  // Небольшое описание профиля
  final List<String> _interests;
  // Небольшое описание профиля
  @override
  @JsonKey()
  List<String> get interests {
    if (_interests is EqualUnmodifiableListView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interests);
  }

  // Интересы
  // Социальные сети
  // Ключ - название соцсети (например, 'vk', 'telegram', 'instagram'), Значение - ссылка
  final Map<String, String> _socialLinks;
  // Интересы
  // Социальные сети
  // Ключ - название соцсети (например, 'vk', 'telegram', 'instagram'), Значение - ссылка
  @override
  @JsonKey()
  Map<String, String> get socialLinks {
    if (_socialLinks is EqualUnmodifiableMapView) return _socialLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_socialLinks);
  }

  // Контакты
  @override
  final String email;
  // Email
  // Игровые/приложенческие статы
  @override
  final String? avatarUrl;
  // Ссылка на фото
  @override
  @JsonKey()
  final int trophies;

  @override
  String toString() {
    return 'UserEntity(id: $id, firstName: $firstName, lastName: $lastName, nickname: $nickname, birthDate: $birthDate, city: $city, bio: $bio, interests: $interests, socialLinks: $socialLinks, email: $email, avatarUrl: $avatarUrl, trophies: $trophies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            const DeepCollectionEquality().equals(
              other._interests,
              _interests,
            ) &&
            const DeepCollectionEquality().equals(
              other._socialLinks,
              _socialLinks,
            ) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.trophies, trophies) ||
                other.trophies == trophies));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    firstName,
    lastName,
    nickname,
    birthDate,
    city,
    bio,
    const DeepCollectionEquality().hash(_interests),
    const DeepCollectionEquality().hash(_socialLinks),
    email,
    avatarUrl,
    trophies,
  );

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserEntityImplCopyWith<_$UserEntityImpl> get copyWith =>
      __$$UserEntityImplCopyWithImpl<_$UserEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserEntityImplToJson(this);
  }
}

abstract class _UserEntity extends UserEntity {
  const factory _UserEntity({
    required final String id,
    required final String firstName,
    required final String lastName,
    required final String nickname,
    final DateTime? birthDate,
    final String? city,
    final String? bio,
    final List<String> interests,
    final Map<String, String> socialLinks,
    required final String email,
    final String? avatarUrl,
    final int trophies,
  }) = _$UserEntityImpl;
  const _UserEntity._() : super._();

  factory _UserEntity.fromJson(Map<String, dynamic> json) =
      _$UserEntityImpl.fromJson;

  @override
  String get id; // ID из Firebase Auth
  // Личная информация
  @override
  String get firstName; // Имя
  @override
  String get lastName; // Фамилия
  @override
  String get nickname; // Никнейм (@max_maximov)
  @override
  DateTime? get birthDate; // Дата рождения
  @override
  String? get city; // Город
  // Детали профиля (Bio, Интересы)
  @override
  String? get bio; // Небольшое описание профиля
  @override
  List<String> get interests; // Интересы
  // Социальные сети
  // Ключ - название соцсети (например, 'vk', 'telegram', 'instagram'), Значение - ссылка
  @override
  Map<String, String> get socialLinks; // Контакты
  @override
  String get email; // Email
  // Игровые/приложенческие статы
  @override
  String? get avatarUrl; // Ссылка на фото
  @override
  int get trophies;

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserEntityImplCopyWith<_$UserEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
