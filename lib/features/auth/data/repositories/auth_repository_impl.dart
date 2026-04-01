import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/user_entity.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  UserEntity? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return UserEntity(id: user.uid, email: user.email ?? '');
  }

  @override
  Stream<String?> get authStateChanges =>
      _firebaseAuth.authStateChanges().map((user) => user?.uid);

  @override
  Future<UserEntity?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        return UserEntity(id: user.uid, email: user.email ?? '');
      }
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Пользователь с таким email не найден.');
      } else if (e.code == 'invalid-credential') {
        throw Exception('Неверный логин или пароль.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Некорректный формат email.');
      }
      throw Exception(e.message ?? 'Ошибка авторизации.');
    }
  }

  @override
  Future<UserEntity?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        return UserEntity(id: user.uid, email: user.email ?? '');
      }
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Слишком слабый пароль (минимум 6 символов).');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Этот email уже зарегистрирован.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Некорректный формат email.');
      }
      throw Exception(e.message ?? 'Ошибка регистрации.');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
