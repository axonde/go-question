import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../source/datasource.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  UserEntity? getCurrentUser() {
    return _remoteDataSource.getCurrentUser()?.toDomain();
  }

  @override
  Stream<String?> get authStateChanges => throw UnimplementedError();

  @override
  Future<void> signInWithPhoneNumber({
    required String phoneNumber,
    required Function(String code) onCodeSent,
    required Function(String error) onError,
  }) {
    return _remoteDataSource.signInWithPhoneNumber(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onError: onError,
    );
  }

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
