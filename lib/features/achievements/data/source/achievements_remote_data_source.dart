import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_question/core/constants/achievement_constants.dart';
import 'package:go_question/features/achievements/domain/entities/achievement_view.dart';
import 'package:go_question/features/achievements/domain/errors/achievement_exceptions.dart';
import 'package:go_question/features/profile/constants/profile_firestore.dart';

abstract interface class IAchievementsRemoteDataSource {
  Future<List<AchievementView>> getAchievements(String uid);

  Future<List<AchievementView>> openAchievements(String uid);

  Future<void> markAllAsViewed(String uid);

  Future<void> unlockAchievement({
    required String uid,
    required String achievementId,
    bool markAsUnseen = true,
  });
}

class AchievementsRemoteDataSourceImpl
    implements IAchievementsRemoteDataSource {
  final FirebaseFirestore _firestore;

  const AchievementsRemoteDataSourceImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection(ProfileFirestoreConstants.usersCollection);

  @override
  Future<List<AchievementView>> getAchievements(String uid) async {
    try {
      final doc = await _usersRef.doc(uid).get();
      if (!doc.exists) {
        throw const AchievementProfileNotFoundException();
      }

      final data = doc.data() ?? <String, dynamic>{};
      final unlockedIds = _readStringSet(
        data[ProfileFirestoreConstants.fieldAchievementIds],
      );
      final unseenIds = _readStringSet(
        data[ProfileFirestoreConstants.fieldUnseenAchievementIds],
      );

      return _buildAchievements(unlockedIds: unlockedIds, unseenIds: unseenIds);
    } on AchievementProfileNotFoundException {
      rethrow;
    } on FirebaseException catch (_) {
      throw const AchievementFetchException();
    } catch (_) {
      throw const AchievementFetchException();
    }
  }

  @override
  Future<List<AchievementView>> openAchievements(String uid) async {
    try {
      final state = await _firestore.runTransaction<_AchievementState>((
        tx,
      ) async {
        final userRef = _usersRef.doc(uid);
        final snapshot = await tx.get(userRef);
        if (!snapshot.exists) {
          throw const AchievementProfileNotFoundException();
        }

        final data = snapshot.data() ?? <String, dynamic>{};
        final unlockedIds = _readStringSet(
          data[ProfileFirestoreConstants.fieldAchievementIds],
        );
        final unseenIds = _readStringSet(
          data[ProfileFirestoreConstants.fieldUnseenAchievementIds],
        );

        if (!unlockedIds.contains(AchievementConstants.firstOpenAchievements)) {
          unlockedIds.add(AchievementConstants.firstOpenAchievements);
          unseenIds.add(AchievementConstants.firstOpenAchievements);
          tx.update(userRef, {
            ProfileFirestoreConstants.fieldAchievementIds:
                FieldValue.arrayUnion(const <String>[
                  AchievementConstants.firstOpenAchievements,
                ]),
            ProfileFirestoreConstants.fieldUnseenAchievementIds:
                FieldValue.arrayUnion(const <String>[
                  AchievementConstants.firstOpenAchievements,
                ]),
            ProfileFirestoreConstants.fieldUpdatedAt:
                FieldValue.serverTimestamp(),
          });
        }

        return _AchievementState(
          unlockedIds: unlockedIds,
          unseenIds: unseenIds,
        );
      });

      return _buildAchievements(
        unlockedIds: state.unlockedIds,
        unseenIds: state.unseenIds,
      );
    } on AchievementProfileNotFoundException {
      rethrow;
    } on FirebaseException catch (_) {
      throw const AchievementUpdateException();
    } catch (_) {
      throw const AchievementUpdateException();
    }
  }

  @override
  Future<void> markAllAsViewed(String uid) async {
    try {
      await _usersRef.doc(uid).update({
        ProfileFirestoreConstants.fieldUnseenAchievementIds: const <String>[],
        ProfileFirestoreConstants.fieldUpdatedAt: FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (_) {
      throw const AchievementUpdateException();
    } catch (_) {
      throw const AchievementUpdateException();
    }
  }

  @override
  Future<void> unlockAchievement({
    required String uid,
    required String achievementId,
    bool markAsUnseen = true,
  }) async {
    try {
      final updates = <String, dynamic>{
        ProfileFirestoreConstants.fieldAchievementIds: FieldValue.arrayUnion(
          <String>[achievementId],
        ),
        ProfileFirestoreConstants.fieldUpdatedAt: FieldValue.serverTimestamp(),
      };

      if (markAsUnseen) {
        updates[ProfileFirestoreConstants.fieldUnseenAchievementIds] =
            FieldValue.arrayUnion(<String>[achievementId]);
      }

      await _usersRef.doc(uid).update(updates);
    } on FirebaseException catch (_) {
      throw const AchievementUpdateException();
    } catch (_) {
      throw const AchievementUpdateException();
    }
  }

  Set<String> _readStringSet(Object? raw) {
    final values = raw as List<dynamic>? ?? const <dynamic>[];
    return values
        .map((value) => value.toString().trim())
        .where((value) => value.isNotEmpty)
        .toSet();
  }

  List<AchievementView> _buildAchievements({
    required Set<String> unlockedIds,
    required Set<String> unseenIds,
  }) {
    return AchievementConstants.allIds
        .map(
          (id) => AchievementView(
            id: id,
            title: AchievementConstants.titles[id] ?? id,
            description: AchievementConstants.descriptions[id] ?? '',
            isUnlocked: unlockedIds.contains(id),
            isViewed: !unseenIds.contains(id),
          ),
        )
        .toList(growable: false);
  }
}

class _AchievementState {
  final Set<String> unlockedIds;
  final Set<String> unseenIds;

  const _AchievementState({required this.unlockedIds, required this.unseenIds});
}
