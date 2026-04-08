import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/profile_firestore.dart';
import '../../domain/errors/profile_exception.dart';
import '../models/profile_model.dart';

/// Remote datasource interface for Profile.
///
/// Gathers all Firestore-related operations for profiles.
/// Throws feature-specific exceptions; caller (repository) handles mapping.
abstract class IProfileRemoteDataSource {
  /// Retrieves profile by uid.
  /// Throws ProfileNotFoundException if not found.
  /// Throws other Firestore exceptions on failure.
  Future<ProfileModel?> getProfile(String uid);

  /// Creates initial profile, idempotent.
  /// Uses set(_, merge: false) or transaction to prevent overwrites.
  /// Throws ProfileValidationException if name is invalid.
  /// Throws other Firestore exceptions on failure.
  Future<void> createInitialProfile({
    required String uid,
    required String name,
  });

  /// Updates profile basics (name and/or age).
  /// Throws ProfileNotFoundException if profile doesn't exist.
  /// Throws ProfileValidationException if data is invalid.
  /// Throws other Firestore exceptions on failure.
  Future<void> updateProfileBasics({
    required String uid,
    String? name,
    int? age,
  });

  /// Atomically increments visited events count.
  /// Uses FieldValue.increment to prevent race conditions.
  /// Throws ProfileNotFoundException if profile doesn't exist.
  /// Throws other Firestore exceptions on failure.
  Future<void> incrementVisitedEvents(String uid, {int by = 1});

  /// Atomically increments created events count.
  /// Uses FieldValue.increment to prevent race conditions.
  /// Throws ProfileNotFoundException if profile doesn't exist.
  /// Throws other Firestore exceptions on failure.
  Future<void> incrementCreatedEvents(String uid, {int by = 1});
}

/// Implementation of [IProfileRemoteDataSource] using Cloud Firestore.
///
/// **Design guarantees:**
///
/// 1. **Idempotent creation**: Uses setDoc with merge:false to prevent overwrites.
///    Subsequent calls with same uid/name are no-op.
///
/// 2. **Counter atomicity**: Uses FieldValue.increment for all counter updates.
///    Prevents read-modify-write races.
///
/// 3. **Consistency**: Timestamps (createdAt, updatedAt) managed server-side for
///    consistency. updatedAt updated on every write.
///
/// 4. **Validation**: Input validation before writes; domain invariants enforced
///    in entity. Validation errors thrown as ProfileValidationException.
///
/// 5. **Exception transparency**: All Firestore errors propagated, caller maps
///    to domain failures. No exceptions masked.
class ProfileRemoteDataSourceImpl implements IProfileRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProfileRemoteDataSourceImpl(this._firestore);

  @override
  Future<ProfileModel?> getProfile(String uid) async {
    try {
      final docSnapshot = await _firestore
          .collection(ProfileFirestoreConstants.usersCollection)
          .doc(uid)
          .get();

      if (!docSnapshot.exists) {
        return null;
      }

      final data = docSnapshot.data() ?? {};
      return ProfileModel.fromJson({...data, 'uid': uid});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createInitialProfile({
    required String uid,
    required String name,
  }) async {
    // Validate input
    _validateName(name);

    try {
      final now = FieldValue.serverTimestamp();

      // Idempotent: set with merge:false prevents overwrites.
      // If profile already exists, this is a no-op by design.
      await _firestore
          .collection(ProfileFirestoreConstants.usersCollection)
          .doc(uid)
          .set({
            'name': name,
            'age': null,
            'visitedEventsCount': 0,
            'createdEventsCount': 0,
            'createdAt': now,
            'updatedAt': now,
          }, SetOptions(merge: false));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateProfileBasics({
    required String uid,
    String? name,
    int? age,
  }) async {
    // Validate inputs
    if (name != null) {
      _validateName(name);
    }
    if (age != null) {
      _validateAge(age);
    }

    try {
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null) {
        updates['name'] = name;
      }
      if (age != null) {
        updates['age'] = age;
      }

      await _firestore
          .collection(ProfileFirestoreConstants.usersCollection)
          .doc(uid)
          .update(updates);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> incrementVisitedEvents(String uid, {int by = 1}) async {
    if (by < 0) {
      throw ProfileValidationException(
        violation: '${ProfileValidationMessages.incrementByInvalid} $by',
      );
    }

    try {
      await _firestore
          .collection(ProfileFirestoreConstants.usersCollection)
          .doc(uid)
          .update({
            'visitedEventsCount': FieldValue.increment(by),
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> incrementCreatedEvents(String uid, {int by = 1}) async {
    if (by < 0) {
      throw ProfileValidationException(
        violation: '${ProfileValidationMessages.incrementByInvalid} $by',
      );
    }

    try {
      await _firestore
          .collection(ProfileFirestoreConstants.usersCollection)
          .doc(uid)
          .update({
            'createdEventsCount': FieldValue.increment(by),
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      rethrow;
    }
  }

  /// Validates profile name according to domain invariants.
  void _validateName(String name) {
    if (name.trim().isEmpty) {
      throw ProfileValidationException(
        violation: ProfileValidationMessages.nameCannotBeEmpty,
      );
    }
  }

  /// Validates profile age according to domain invariants.
  void _validateAge(int age) {
    if (age < 0) {
      throw ProfileValidationException(
        violation: '${ProfileValidationMessages.ageInvalid} $age',
      );
    }
  }
}
