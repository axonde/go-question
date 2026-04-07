import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/profile/domain/entities/user_profile_entity.dart';
import 'package:go_question/features/profile/domain/errors/profile_failure.dart';

abstract interface class IUserRepository {
  Future<Result<UserProfile, ProfileFailure>> getUserProfile(String uid);
}
