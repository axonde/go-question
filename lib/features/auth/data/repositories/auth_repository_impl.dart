import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../source/datasource.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  UserEntity? getCurrentUser() =>
      _remoteDataSource.getCurrentUser()?.toDomain();

  @override
  bool isCurrentUserEmailVerified() =>
      _remoteDataSource.isCurrentUserEmailVerified();

  @override
  Stream<String?> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  Future<UserEntity?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final model = await _remoteDataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return model?.toDomain();
  }

  @override
  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) => _remoteDataSource.signUpWithEmailAndPassword(
    email: email,
    password: password,
    name: name,
  );

  @override
  Future<UserEntity?> signInWithGoogle() async {
    final model = await _remoteDataSource.signInWithGoogle();
    return model?.toDomain();
  }

  @override
  Future<void> sendEmailVerification() =>
      _remoteDataSource.sendEmailVerification();

  @override
  Future<bool> checkEmailVerified() => _remoteDataSource.checkEmailVerified();

  @override
  Future<void> deleteCurrentUser() => _remoteDataSource.deleteCurrentUser();

  @override
  Future<void> saveUserToFirestore() => _remoteDataSource.saveUserToFirestore();

  @override
  Future<void> signOut() => _remoteDataSource.signOut();
}
