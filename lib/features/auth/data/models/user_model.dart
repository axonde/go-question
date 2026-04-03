import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String uid,
    required String name,
    required String email,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromFirebaseUser(firebase.User user) {
    return UserModel(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

  UserEntity toDomain() {
    return UserEntity(uid: uid, name: name, email: email);
  }
}
