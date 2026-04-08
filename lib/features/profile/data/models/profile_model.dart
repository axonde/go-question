import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/timestamp_converter.dart';
import '../../domain/entities/profile.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

/// ProfileModel - DTO for Firestore storage.
///
/// Maps to users/{uid} document with fields:
/// - name: String
/// - age: int | null
/// - visitedEventsCount: int
/// - createdEventsCount: int
/// - createdAt: Timestamp
/// - updatedAt: Timestamp
@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String uid,
    required String name,
    int? age,
    @Default(0) int visitedEventsCount,
    @Default(0) int createdEventsCount,
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
      name: name,
      age: age,
      visitedEventsCount: visitedEventsCount,
      createdEventsCount: createdEventsCount,
    );
  }

  /// Creates DTO from domain entity.
  static ProfileModel fromEntity(Profile profile) {
    final now = DateTime.now();
    return ProfileModel(
      uid: profile.uid,
      name: profile.name,
      age: profile.age,
      visitedEventsCount: profile.visitedEventsCount,
      createdEventsCount: profile.createdEventsCount,
      createdAt: now,
      updatedAt: now,
    );
  }
}
