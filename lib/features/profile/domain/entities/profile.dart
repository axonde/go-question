import 'package:freezed_annotation/freezed_annotation.dart';

import '../../constants/profile_firestore.dart';

part 'profile.freezed.dart';

/// Profile entity.
///
/// Invariants enforced:
/// - uid: required, immutable
/// - email: required, non-empty after trim
/// - name: required, non-empty after trim
/// - nickname: required, non-empty after trim
/// - birthDate: nullable, must not be in future when present
/// - trophies: >= 0, default 0
/// - counters: >= 0, default 0
/// - event id lists: IDs must be non-empty strings
///
/// Broken invariants throw ArgumentError.
@freezed
class Profile with _$Profile {
  const factory Profile({
    required String uid,
    required String email,
    required String name,
    required String nickname,
    DateTime? birthDate,
    String? city,
    String? bio,
    String? avatarUrl,
    String? gender,
    int? age,
    @Default(0.0) double rating,
    @Default(0) int trophies,
    @Default(0) int visitedEventsCount,
    @Default(0) int createdEventsCount,
    @Default(<String>[]) List<String> joinedEventIds,
    @Default(<String>[]) List<String> createdEventIds,
    @Default(<String>[]) List<String> friendIds,
    @Default(<String>[]) List<String> incomingFriendRequestIds,
    @Default(<String>[]) List<String> outgoingFriendRequestIds,
    @Default(<String>[]) List<String> blockedUserIds,
    DateTime? lastSeenAt,
  }) = _Profile;

  const Profile._();

  /// Validates all invariants.
  /// Throws ArgumentError if any invariant is broken.
  void validate() {
    if (uid.isEmpty) {
      throw ArgumentError(ProfileValidationMessages.uidCannotBeEmpty);
    }
    if (email.trim().isEmpty) {
      throw ArgumentError(ProfileValidationMessages.emailCannotBeEmpty);
    }
    if (name.trim().isEmpty) {
      throw ArgumentError(ProfileValidationMessages.nameCannotBeEmpty);
    }
    if (nickname.trim().isEmpty) {
      throw ArgumentError(ProfileValidationMessages.nicknameCannotBeEmpty);
    }
    if (birthDate != null && birthDate!.isAfter(DateTime.now())) {
      throw ArgumentError(
        '${ProfileValidationMessages.birthDateInFuture} $birthDate',
      );
    }
    if (trophies < 0) {
      throw ArgumentError(ProfileValidationMessages.trophiesInvalid);
    }
    if (visitedEventsCount < 0) {
      throw ArgumentError(ProfileValidationMessages.visitedEventsCountInvalid);
    }
    if (createdEventsCount < 0) {
      throw ArgumentError(ProfileValidationMessages.createdEventsCountInvalid);
    }
    if (joinedEventIds.any((id) => id.trim().isEmpty)) {
      throw ArgumentError(ProfileValidationMessages.eventIdCannotBeEmpty);
    }
    if (createdEventIds.any((id) => id.trim().isEmpty)) {
      throw ArgumentError(ProfileValidationMessages.eventIdCannotBeEmpty);
    }
    if (friendIds.any((id) => id.trim().isEmpty)) {
      throw ArgumentError(ProfileValidationMessages.eventIdCannotBeEmpty);
    }
    if (incomingFriendRequestIds.any((id) => id.trim().isEmpty)) {
      throw ArgumentError(ProfileValidationMessages.eventIdCannotBeEmpty);
    }
    if (outgoingFriendRequestIds.any((id) => id.trim().isEmpty)) {
      throw ArgumentError(ProfileValidationMessages.eventIdCannotBeEmpty);
    }
    if (blockedUserIds.any((id) => id.trim().isEmpty)) {
      throw ArgumentError(ProfileValidationMessages.eventIdCannotBeEmpty);
    }
  }
}
