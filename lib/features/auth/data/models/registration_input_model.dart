import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../../domain/entities/registration_input_entity.dart';

extension RegistrationInputFirebaseMapper on firebase.User {
  RegistrationInput toRegistrationInput() {
    return RegistrationInput(
      uid: uid,
      nickname: displayName ?? '',
      email: email ?? '',
    );
  }
}
