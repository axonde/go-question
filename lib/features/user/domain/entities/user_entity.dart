import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

/// Доменная сущность пользователя.
/// Единый объект для всего приложения, вынесенный в отдельную фичу 'user'.
@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String uid,
    required String name,
    required String email,
    String? photoUrl,
    String? bio,
    int? yearsOld,
    String? city,
    String? username,
    Map<String, String>? socialMedia,
  }) = _UserEntity;
}
