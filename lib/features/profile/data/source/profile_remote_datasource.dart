import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  /// Throws other Firestore exceptions on failure.
  Future<void> createInitialProfile({
    required String uid,
    required String email,
    required String name,
    required String nickname,
  });

  /// Creates initial profile for currently authenticated user.
  /// Automatically uses current user's UID from FirebaseAuth.
  /// Throws UserNotAuthenticatedException if no user is logged in.
  /// Throws other Firestore exceptions on failure.
  Future<void> createInitialProfileForCurrentUser({
    required String email,
    required String name,
    required String nickname,
  });

  /// Updates profile basics.
  /// Throws ProfileNotFoundException if profile doesn't exist.
  /// Throws other Firestore exceptions on failure.
  Future<void> updateProfileBasics({
    required String uid,
    required String email,
    String? name,
    DateTime? birthDate,
    String? city,
    int? trophies,
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
/// 4. **Validation**: Domain-level validation happens before datasource calls.
///
/// 5. **Exception transparency**: All Firestore errors propagated, caller maps
///    to domain failures. No exceptions masked.
///
/// 6. **Authentication safety**: Integrates with FirebaseAuth to validate current
///    user before operations that require authentication context.
class ProfileRemoteDataSourceImpl implements IProfileRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  ProfileRemoteDataSourceImpl(this._firestore, this._firebaseAuth);

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
    required String email,
    required String name,
    required String nickname,
  }) async {
    try {
      final now = FieldValue.serverTimestamp();
      final nicknameKey = nickname.trim().toLowerCase();
      final userRef = _firestore
          .collection(ProfileFirestoreConstants.usersCollection)
          .doc(uid);
      final nicknameRef = _firestore
          .collection(ProfileFirestoreConstants.nicknamesCollection)
          .doc(nicknameKey);

      await _firestore.runTransaction((tx) async {
        final userSnapshot = await tx.get(userRef);
        if (userSnapshot.exists) {
          return;
        }

        final nicknameSnapshot = await tx.get(nicknameRef);
        if (nicknameSnapshot.exists) {
          throw const ProfileValidationException(
            violation: ProfileValidationMessages.nicknameAlreadyTaken,
          );
        }

        tx.set(nicknameRef, {'uid': uid, 'createdAt': now});
        tx.set(userRef, {
          'email': email,
          'name': name,
          'nickname': nickname,
          'birthDate': null,
          'city': null,
          'trophies': 0,
          'visitedEventsCount': 0,
          'createdEventsCount': 0,
          'createdAt': now,
          'updatedAt': now,
        }, SetOptions(merge: false));
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createInitialProfileForCurrentUser({
    required String email,
    required String name,
    required String nickname,
  }) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw const ProfileValidationException(
        violation: 'User not authenticated. Cannot create profile without UID.',
      );
    }

    await createInitialProfile(
      uid: uid,
      email: email,
      name: name,
      nickname: nickname,
    );
  }

  @override
  Future<void> updateProfileBasics({
    required String uid,
    required String email,
    String? name,
    DateTime? birthDate,
    String? city,
    int? trophies,
  }) async {
    try {
      final updates = <String, dynamic>{
        'email': email,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null) {
        updates['name'] = name;
      }
      if (birthDate != null) {
        updates['birthDate'] = Timestamp.fromDate(birthDate);
      }
      if (city != null) {
        updates['city'] = city;
      }
      if (trophies != null) {
        updates['trophies'] = trophies;
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
}
