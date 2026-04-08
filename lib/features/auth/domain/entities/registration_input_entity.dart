import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_input_entity.freezed.dart';

@freezed
class RegistrationInput with _$RegistrationInput {
  const factory RegistrationInput({
    required String uid,
    required String nickname,
    required String email,
    String? password,
  }) = _UserEntity;
}
