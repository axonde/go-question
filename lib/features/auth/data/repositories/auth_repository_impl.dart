import 'package:go_question/features/user/domain/entities/user_entity.dart';
import 'package:go_question/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:go_question/features/auth/data/source/datasource.dart';

/// Реализация репозитория аутентификации.
/// Взаимодействует с удалённым источником данных (Firebase Auth).
class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  UserEntity? getCurrentUser() {
    final userModel = _remoteDataSource.getCurrentUser();
    return userModel?.toDomain();
  }

  @override
  Future<UserEntity?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userModel = await _remoteDataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userModel?.toDomain();
  }

  @override
  Future<UserEntity?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    final userModel = await _remoteDataSource.signUpWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );
    return userModel?.toDomain();
  }

  @override
  Future<void> signOut() {
    return _remoteDataSource.signOut();
  }
}
