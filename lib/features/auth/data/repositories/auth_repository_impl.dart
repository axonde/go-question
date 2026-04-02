import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../source/datasource.dart';

/// Реализация репозитория аутентификации.
/// Делегирует вызовы в [IAuthRemoteDataSource] и конвертирует
/// DataLayer-модели (UserModel) в Domain-сущности (UserEntity).
class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  UserEntity? getCurrentUser() {
    return _remoteDataSource.getCurrentUser()?.toDomain();
  }

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
  Future<UserEntity?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    final model = await _remoteDataSource.signUpWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );
    return model?.toDomain();
  }

  @override
  Future<void> signOut() {
    return _remoteDataSource.signOut();
  }
}
