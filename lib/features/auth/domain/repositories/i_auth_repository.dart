import '../entities/user_entity.dart';

abstract class IAuthRepository {
  UserEntity? getCurrentUser();
  bool isCurrentUserEmailVerified();
  Stream<String?> get authStateChanges;

  Future<UserEntity?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Возвращает email (не UserEntity) — пользователь ещё не верифицирован
  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<UserEntity?> signInWithGoogle();

  Future<void> sendEmailVerification();
  Future<bool> checkEmailVerified();
  Future<void> deleteCurrentUser();
  Future<void> saveUserToFirestore();

  Future<void> signOut();
}
