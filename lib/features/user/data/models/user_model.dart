import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Единая Data-модель пользователя в фиче 'user'.
/// Умеет мапиться из Firebase Auth и Firestore.
@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String uid,
    required String name,
    required String email,
    String? photoUrl,
    String? bio,
    int? yearsOld,
    String? city,
    String? username,
    Map<String, String>? socialMedia,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromFirebaseUser(firebase.User user) {
    return UserModel(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
      bio: data['bio'] as String?,
      yearsOld: data['yearsOld'] as int?,
      city: data['city'] as String?,
      username: data['username'] as String?,
      socialMedia: (data['socialMedia'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as String),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (bio != null) 'bio': bio,
      if (yearsOld != null) 'yearsOld': yearsOld,
      if (city != null) 'city': city,
      if (username != null) 'username': username,
      if (socialMedia != null) 'socialMedia': socialMedia,
    };
  }

  UserEntity toDomain() {
    return UserEntity(
      uid: uid,
      name: name,
      email: email,
      photoUrl: photoUrl,
      bio: bio,
      yearsOld: yearsOld,
      city: city,
      username: username,
      socialMedia: socialMedia,
    );
  }
}
