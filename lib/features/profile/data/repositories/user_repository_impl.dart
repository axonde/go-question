import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/profile/data/models/user_profile_model.dart';
import 'package:go_question/features/profile/domain/entities/user_profile_entity.dart';
import 'package:go_question/features/profile/domain/errors/profile_failure.dart';
import 'package:go_question/features/profile/domain/repositories/i_user_repository.dart';

class UserRepositoryImpl implements IUserRepository {
  final FirebaseFirestore _firestore;

  const UserRepositoryImpl(this._firestore);

  @override
  Future<Result<UserProfile, ProfileFailure>> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists || doc.data() == null) {
        return const Failure(
          ProfileFailure(
            ProfileFailureType.notFound,
            message: 'User profile not found',
          ),
        );
      }

      final model = UserProfileModel.fromFirestore(uid, doc.data()!);
      return Success(model.toEntity());
    } catch (e) {
      return Failure(
        ProfileFailure(
          ProfileFailureType.server,
          message: 'Failed to load profile: ${e.runtimeType}',
        ),
      );
    }
  }
}
