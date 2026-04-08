import 'package:freezed_annotation/freezed_annotation.dart';

import '../../constants/profile_firestore.dart';

part 'profile.freezed.dart';

/// Profile entity.
///
/// Invariants enforced:
/// - uid: required, immutable
/// - name: required, non-empty after trim
/// - age: nullable, >= 0 when present
/// - counters: >= 0, default 0
///
/// Broken invariants throw ArgumentError.
@freezed
class Profile with _$Profile {
  const factory Profile({
    required String uid,
    required String name,
    int? age,
    @Default(0) int visitedEventsCount,
    @Default(0) int createdEventsCount,
  }) = _Profile;

  const Profile._();

  /// Validates all invariants.
  /// Throws ArgumentError if any invariant is broken.
  void validate() {
    if (uid.isEmpty) {
      throw ArgumentError(ProfileValidationMessages.uidCannotBeEmpty);
    }
    if (name.trim().isEmpty) {
      throw ArgumentError(ProfileValidationMessages.nameCannotBeEmpty);
    }
    if (age != null && age! < 0) {
      throw ArgumentError('${ProfileValidationMessages.ageInvalid} $age');
    }
    if (visitedEventsCount < 0) {
      throw ArgumentError(ProfileValidationMessages.visitedEventsCountInvalid);
    }
    if (createdEventsCount < 0) {
      throw ArgumentError(ProfileValidationMessages.createdEventsCountInvalid);
    }
  }
}
