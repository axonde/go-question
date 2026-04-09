import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../../domain/entities/registration_input_entity.dart';

extension RegistrationInputFirebaseMapper on firebase.User {
  RegistrationInput toRegistrationInput() {
    final emailPrefix = (email ?? '').trim().split('@').first;
    final fallbackNickname = emailPrefix.isEmpty ? uid : emailPrefix;
    return RegistrationInput(
      uid: uid,
      nickname: (displayName ?? '').trim().isEmpty
          ? fallbackNickname
          : displayName!.trim(),
      email: email ?? '',
    );
  }
}
