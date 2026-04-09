import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/timestamp_converter.dart';
import '../../domain/entities/profile.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

/// ProfileModel - DTO for Firestore storage.
///
/// Maps to users/{uid} document with fields:
/// - email: String
/// - name: String
/// - nickname: String
/// - birthDate: Timestamp | null
/// - city: String | null
/// - bio: String | null
/// - avatarUrl: String | null
/// - gender: String | null
/// - age: int | null
/// - rating: double
/// - trophies: int
/// - visitedEventsCount: int
/// - createdEventsCount: int
/// - joinedEventIds: `List<String>`
/// - createdEventIds: `List<String>`
/// - friendIds: `List<String>`
/// - incomingFriendRequestIds: `List<String>`
/// - outgoingFriendRequestIds: `List<String>`
/// - blockedUserIds: `List<String>`
/// - lastSeenAt: Timestamp | null
/// - createdAt: Timestamp
/// - updatedAt: Timestamp
@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String uid,
    required String email,
    required String name,
    required String nickname,
    @TimestampConverter() DateTime? birthDate,
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
    @TimestampConverter() DateTime? lastSeenAt,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  const ProfileModel._();

  /// Converts DTO to domain entity.
  Profile toEntity() {
    return Profile(
      uid: uid,
      email: email,
      name: name,
      nickname: nickname,
      birthDate: birthDate,
      city: city,
      bio: bio,
      avatarUrl: avatarUrl,
      gender: gender,
      age: age,
      rating: rating,
      trophies: trophies,
      visitedEventsCount: visitedEventsCount,
      createdEventsCount: createdEventsCount,
      joinedEventIds: joinedEventIds,
      createdEventIds: createdEventIds,
      friendIds: friendIds,
      incomingFriendRequestIds: incomingFriendRequestIds,
      outgoingFriendRequestIds: outgoingFriendRequestIds,
      blockedUserIds: blockedUserIds,
      lastSeenAt: lastSeenAt,
    );
  }

  /// Creates DTO from domain entity.
  static ProfileModel fromEntity(Profile profile) {
    final now = DateTime.now();
    return ProfileModel(
      uid: profile.uid,
      email: profile.email,
      name: profile.name,
      nickname: profile.nickname,
      birthDate: profile.birthDate,
      city: profile.city,
      bio: profile.bio,
      avatarUrl: profile.avatarUrl,
      gender: profile.gender,
      age: profile.age,
      rating: profile.rating,
      trophies: profile.trophies,
      visitedEventsCount: profile.visitedEventsCount,
      createdEventsCount: profile.createdEventsCount,
      joinedEventIds: profile.joinedEventIds,
      createdEventIds: profile.createdEventIds,
      friendIds: profile.friendIds,
      incomingFriendRequestIds: profile.incomingFriendRequestIds,
      outgoingFriendRequestIds: profile.outgoingFriendRequestIds,
      blockedUserIds: profile.blockedUserIds,
      lastSeenAt: profile.lastSeenAt,
      createdAt: now,
      updatedAt: now,
    );
  }
}
