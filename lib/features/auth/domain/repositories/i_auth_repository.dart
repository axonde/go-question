import '../../../../core/types/result.dart';
import '../entities/registration_input_entity.dart';
import '../errors/auth_failure.dart';

abstract class IAuthRepository {
  RegistrationInput? getCurrentUser();
  bool isCurrentUserEmailVerified();
  Stream<String?> get authStateChanges;

  Future<Result<RegistrationInput?, AuthFailure>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Возвращает email (не UserEntity) — пользователь ещё не верифицирован
  Future<Result<String, AuthFailure>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<Result<RegistrationInput?, AuthFailure>> signInWithGoogle();

  Future<Result<Null, AuthFailure>> sendEmailVerification();
  Future<Result<bool, AuthFailure>> checkEmailVerified();
  Future<Result<Null, AuthFailure>> deleteCurrentUser();

  Future<Result<Null, AuthFailure>> signOut();
}
