import 'package:go_question/core/network/network_info.dart';

import '../../../../core/types/result.dart';
import '../../domain/entities/registration_input_entity.dart';
import '../../domain/errors/auth_exception_to_failure_mapper.dart';
import '../../domain/errors/auth_failure.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../source/datasource.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource _remoteDataSource;
  final AuthExceptionToFailureMapper _errorMapper;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._errorMapper,
    this._networkInfo,
  );

  @override
  RegistrationInput? getCurrentUser() => _remoteDataSource.getCurrentUser();

  @override
  bool isCurrentUserEmailVerified() =>
      _remoteDataSource.isCurrentUserEmailVerified();

  @override
  Stream<String?> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  Future<Result<RegistrationInput?, AuthFailure>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _guard<RegistrationInput?>(
      () => _remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Result<String, AuthFailure>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) {
    return _guard<String>(
      () => _remoteDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      ),
    );
  }

  @override
  Future<Result<RegistrationInput?, AuthFailure>> signInWithGoogle() {
    return _guard<RegistrationInput?>(
      () => _remoteDataSource.signInWithGoogle(),
    );
  }

  @override
  Future<Result<Null, AuthFailure>> sendEmailVerification() {
    return _guard<Null>(() async {
      await _remoteDataSource.sendEmailVerification();
      return null;
    });
  }

  @override
  Future<Result<bool, AuthFailure>> checkEmailVerified() {
    return _guard<bool>(() => _remoteDataSource.checkEmailVerified());
  }

  @override
  Future<Result<Null, AuthFailure>> deleteCurrentUser() {
    return _guard<Null>(() async {
      await _remoteDataSource.deleteCurrentUser();
      return null;
    });
  }

  @override
  Future<Result<Null, AuthFailure>> signOut() {
    return _guard<Null>(() async {
      await _remoteDataSource.signOut();
      return null;
    });
  }

  Future<Result<T, AuthFailure>> _guard<T>(Future<T> Function() action) async {
    if (!await _networkInfo.isConnected) {
      return Failure<T, AuthFailure>(
        const AuthFailure(AuthFailureType.network),
      );
    }

    try {
      return Success<T, AuthFailure>(await action());
    } catch (error) {
      return Failure<T, AuthFailure>(_errorMapper.map(error));
    }
  }
}
