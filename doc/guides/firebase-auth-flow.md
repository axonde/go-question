# Firebase Auth Flow Implementation Guide

**For**: go-question project  
**Feature**: `lib/features/auth/`  
**Strictness**: `STRICT` — Authentication is security-critical  
**Time estimate**: 4–6 hours (domain + data + tests)

---

## Overview

This guide implements a complete Firebase Auth flow with email/password and Google sign-in, following the project's **layer-first architecture** and **security best practices**.

Key outcomes:
- ✅ Session state persisted securely (no plaintext tokens in storage)
- ✅ User entity immutable with `freezed`
- ✅ All exceptions mapped to typed failures
- ✅ Critical tests covering auth transitions
- ✅ Security review checklist included

**Stack**:
- `firebase_auth` for authentication
- `freezed` for immutable state
- Custom `Result<T, Failure>` for error handling
- Route guards for access control

---

## Architecture

### Domain Contracts

```
domain/
├── entities/
│   └── user.dart              # User entity (immutable)
├── failures/
│   └── auth_failure.dart      # Auth-specific failures
├── repositories/
│   └── auth_repository.dart   # Auth contract
└── usecases/                  # (Optional domain logic)
```

### Data Implementation

```
data/
├── datasources/
│   └── firebase_auth_datasource.dart  # Firebase SDK calls
├── repositories/
│   └── auth_repository_impl.dart      # Implements domain contract
└── mappers/
    └── exception_to_failure_mapper.dart # Exception → Failure mapping
```

### Presentation

```
presentation/
├── bloc/
│   ├── auth_bloc.dart
│   ├── auth_event.dart
│   └── auth_state.dart
├── screens/
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   └── email_verification_screen.dart
└── widgets/
```

### Router Guards

```
lib/config/router/
├── guards/
│   ├── auth_guard.dart        # Only authenticated users can pass
│   └── guest_guard.dart       # Only unauthenticated users can pass
```

---

## Step 1: Domain Layer

### 1.1 User Entity

```dart
// lib/features/auth/domain/entities/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
    required DateTime createdAt,
    required bool emailVerified,
    DateTime? lastSignInAt,
  }) = _User;

  const User._();

  /// Returns true if user is fully set up
  bool get isProfileComplete => displayName != null && photoUrl != null;

  /// Returns true if email is verified
  bool get hasVerifiedEmail => emailVerified;
}
```

### 1.2 Auth Failures

```dart
// lib/features/auth/domain/failures/auth_failure.dart
import 'package:go_question/core/failures/failure.dart';

sealed class AuthFailure extends Failure<AuthFailure> {
  const AuthFailure();

  factory AuthFailure.fromException(Exception exception) {
    // Detailed mapping in data layer
    return AuthFailure.unknown(exception.toString());
  }

  // Public API
  const factory AuthFailure.invalidCredentials() = _InvalidCredentials;
  const factory AuthFailure.emailAlreadyExists() = _EmailAlreadyExists;
  const factory AuthFailure.emailNotFound() = _EmailNotFound;
  const factory AuthFailure.userDisabled() = _UserDisabled;
  const factory AuthFailure.operationNotAllowed() = _OperationNotAllowed;
  const factory AuthFailure.weakPassword() = _WeakPassword;
  const factory AuthFailure.networkError() = _NetworkError;
  const factory AuthFailure.sessionExpired() = _SessionExpired;
  const factory AuthFailure.permissionDenied() = _PermissionDenied;
  const factory AuthFailure.unknown(String message) = _Unknown;
}

// Concrete classes
class _InvalidCredentials extends AuthFailure {
  const _InvalidCredentials();
}

class _EmailAlreadyExists extends AuthFailure {
  const _EmailAlreadyExists();
}

class _EmailNotFound extends AuthFailure {
  const _EmailNotFound();
}

class _UserDisabled extends AuthFailure {
  const _UserDisabled();
}

class _OperationNotAllowed extends AuthFailure {
  const _OperationNotAllowed();
}

class _WeakPassword extends AuthFailure {
  const _WeakPassword();
}

class _NetworkError extends AuthFailure {
  const _NetworkError();
}

class _SessionExpired extends AuthFailure {
  const _SessionExpired();
}

class _PermissionDenied extends AuthFailure {
  const _PermissionDenied();
}

class _Unknown extends AuthFailure {
  final String message;
  const _Unknown(this.message);
}
```

### 1.3 Repository Interface

```dart
// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:go_question/core/models/result.dart';
import '../entities/user.dart';
import '../failures/auth_failure.dart';

abstract class AuthRepository {
  /// Current authenticated user (null if not authenticated)
  User? get currentUser;

  /// Stream of auth state changes
  Stream<User?> get authStateStream;

  /// Sign up with email and password
  Future<Result<User, AuthFailure>> signUpWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with email and password
  Future<Result<User, AuthFailure>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with Google
  Future<Result<User, AuthFailure>> signInWithGoogle();

  /// Sign out
  Future<Result<void, AuthFailure>> signOut();

  /// Send email verification
  Future<Result<void, AuthFailure>> sendEmailVerification();

  /// Check if user email is verified
  Future<Result<bool, AuthFailure>> isEmailVerified();

  /// Refresh user (get latest state from Firebase)
  Future<Result<User, AuthFailure>> refreshUser();

  /// Update user profile
  Future<Result<User, AuthFailure>> updateProfile({
    String? displayName,
    String? photoUrl,
  });

  /// Delete user account
  Future<Result<void, AuthFailure>> deleteAccount();
}
```

---

## Step 2: Data Layer

### 2.1 Firebase Auth DataSource

```dart
// lib/features/auth/data/datasources/firebase_auth_datasource.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class FirebaseAuthDataSource {
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserCredential> signInWithGoogle();

  Future<void> signOut();

  Future<void> sendEmailVerification();

  User? get currentUser;

  Stream<User?> get authStateStream;

  Future<void> reloadUser();

  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
  });

  Future<void> deleteUser();
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  @override
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw UserCancelledException();

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('No user logged in');
      await user.sendEmailVerification();
    } catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User?> get authStateStream => _firebaseAuth.authStateChanges();

  @override
  Future<void> reloadUser() async {
    try {
      await _firebaseAuth.currentUser?.reload();
    } catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('No user logged in');

      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(photoUrl);
    } catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      await _firebaseAuth.currentUser?.delete();
    } catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  // ---- Exception Mapping ----

  Exception _mapFirebaseException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          return InvalidEmailException(e.message ?? '');
        case 'user-disabled':
          return UserDisabledException(e.message ?? '');
        case 'user-not-found':
          return UserNotFoundException(e.message ?? '');
        case 'wrong-password':
          return WrongPasswordException(e.message ?? '');
        case 'email-already-in-use':
          return EmailAlreadyInUseException(e.message ?? '');
        case 'operation-not-allowed':
          return OperationNotAllowedException(e.message ?? '');
        case 'weak-password':
          return WeakPasswordException(e.message ?? '');
        case 'network-request-failed':
          return NetworkException(e.message ?? '');
        case 'account-exists-with-different-credential':
          return AccountExistsWithDifferentCredentialException(e.message ?? '');
        default:
          return AuthException(e.message ?? 'Unknown Firebase error');
      }
    }

    if (e is UserCancelledException) return e;
    if (e is Exception) return e;

    return AuthException('Unknown error: $e');
  }
}

// ---- Custom Exceptions ----
sealed class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
}

class InvalidEmailException extends AuthException {
  const InvalidEmailException(String message) : super(message);
}

class UserDisabledException extends AuthException {
  const UserDisabledException(String message) : super(message);
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException(String message) : super(message);
}

class WrongPasswordException extends AuthException {
  const WrongPasswordException(String message) : super(message);
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException(String message) : super(message);
}

class OperationNotAllowedException extends AuthException {
  const OperationNotAllowedException(String message) : super(message);
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException(String message) : super(message);
}

class NetworkException extends AuthException {
  const NetworkException(String message) : super(message);
}

class AccountExistsWithDifferentCredentialException extends AuthException {
  const AccountExistsWithDifferentCredentialException(String message) : super(message);
}

class UserCancelledException extends AuthException {
  const UserCancelledException() : super('User cancelled sign-in');
}
```

### 2.2 User Mapper

```dart
// lib/features/auth/data/mappers/user_mapper.dart
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:go_question/features/auth/domain/entities/user.dart';

class UserMapper {
  static User toDomain(fb.User firebaseUser) {
    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
      emailVerified: firebaseUser.emailVerified,
      lastSignInAt: firebaseUser.metadata.lastSignInTime,
    );
  }
}
```

### 2.3 Exception to Failure Mapper

```dart
// lib/features/auth/data/mappers/exception_to_failure_mapper.dart
import 'package:go_question/features/auth/domain/failures/auth_failure.dart';
import '../datasources/firebase_auth_datasource.dart';

class ExceptionToFailureMapper {
  static AuthFailure map(Exception exception) {
    if (exception is InvalidEmailException) {
      return AuthFailure.invalidCredentials();
    }

    if (exception is WrongPasswordException) {
      return AuthFailure.invalidCredentials();
    }

    if (exception is UserNotFoundException) {
      return AuthFailure.emailNotFound();
    }

    if (exception is UserDisabledException) {
      return AuthFailure.userDisabled();
    }

    if (exception is EmailAlreadyInUseException) {
      return AuthFailure.emailAlreadyExists();
    }

    if (exception is OperationNotAllowedException) {
      return AuthFailure.operationNotAllowed();
    }

    if (exception is WeakPasswordException) {
      return AuthFailure.weakPassword();
    }

    if (exception is NetworkException) {
      return AuthFailure.networkError();
    }

    if (exception is UserCancelledException) {
      return AuthFailure.permissionDenied();
    }

    return AuthFailure.unknown(exception.toString());
  }
}
```

### 2.4 Repository Implementation

```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:go_question/core/models/result.dart';
import 'package:go_question/features/auth/domain/entities/user.dart';
import 'package:go_question/features/auth/domain/failures/auth_failure.dart';
import 'package:go_question/features/auth/domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../mappers/user_mapper.dart';
import '../mappers/exception_to_failure_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  User? get currentUser {
    final fbUser = _dataSource.currentUser;
    return fbUser != null ? UserMapper.toDomain(fbUser) : null;
  }

  @override
  Stream<User?> get authStateStream {
    return _dataSource.authStateStream.map((fbUser) {
      return fbUser != null ? UserMapper.toDomain(fbUser) : null;
    });
  }

  @override
  Future<Result<User, AuthFailure>> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _dataSource.signUpWithEmail(
        email: email,
        password: password,
      );
      final user = UserMapper.toDomain(credential.user!);
      return Result.success(user);
    } catch (e) {
      return Result.failure(
        ExceptionToFailureMapper.map(e as Exception),
      );
    }
  }

  @override
  Future<Result<User, AuthFailure>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _dataSource.signInWithEmail(
        email: email,
        password: password,
      );
      final user = UserMapper.toDomain(credential.user!);
      return Result.success(user);
    } catch (e) {
      return Result.failure(
        ExceptionToFailureMapper.map(e as Exception),
      );
    }
  }

  @override
  Future<Result<User, AuthFailure>> signInWithGoogle() async {
    try {
      final credential = await _dataSource.signInWithGoogle();
      final user = UserMapper.toDomain(credential.user!);
      return Result.success(user);
    } catch (e) {
      return Result.failure(
        ExceptionToFailureMapper.map(e as Exception),
      );
    }
  }

  @override
  Future<Result<void, AuthFailure>> signOut() async {
    try {
      await _dataSource.signOut();
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        ExceptionToFailureMapper.map(e as Exception),
      );
    }
  }

  @override
  Future<Result<void, AuthFailure>> sendEmailVerification() async {
    try {
      await _dataSource.sendEmailVerification();
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        ExceptionToFailureMapper.map(e as Exception),
      );
    }
  }

  @override
  Future<Result<bool, AuthFailure>> isEmailVerified() async {
    try {
      await _dataSource.reloadUser();
      final user = _dataSource.currentUser;
      return Result.success(user?.emailVerified ?? false);
    } catch (e) {
      return Result.failure(
        ExceptionToFailureMapper.map(e as Exception),
      );
    }
  }

  @override
  Future<Result<User, AuthFailure>> refreshUser() async {
    try {
      await _dataSource.reloadUser();
      final fbUser = _dataSource.currentUser;
      if (fbUser == null) {
        return Result.failure(AuthFailure.sessionExpired());
      }
      return Result.success(UserMapper.toDomain(fbUser));
    } catch (e) {
      return Result.failure(
        ExceptionToFailureMapper.map(e as Exception),
      );
    }
  }

  @override
  Future<Result<User, AuthFailure>> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      await _dataSource.updateUserProfile(
        displayName: displayName,
        photoUrl: photoUrl,
      );
      await _dataSource.reloadUser();
      final fbUser = _dataSource.currentUser;
      if (fbUser == null) return Result.failure(AuthFailure.sessionExpired());
      return Result.success(UserMapper.toDomain(fbUser));
    } catch (e) {
      return Result.failure(
        ExceptionToFailureMapper.map(e as Exception),
      );
    }
  }

  @override
  Future<Result<void, AuthFailure>> deleteAccount() async {
    try {
      await _dataSource.deleteUser();
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        ExceptionToFailureMapper.map(e as Exception),
      );
    }
  }
}
```

---

## Step 3: Presentation Layer (BLoC)

### 3.1 BLoC Events & States

```dart
// lib/features/auth/presentation/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(const AuthState.initial()) {
    on<AuthInitEvent>(_onAuthInit);
    on<SignUpEmailEvent>(_onSignUpEmail);
    on<SignInEmailEvent>(_onSignInEmail);
    on<SignInGoogleEvent>(_onSignInGoogle);
    on<SignOutEvent>(_onSignOut);
    on<SessionExpiredEvent>(_onSessionExpired);
  }

  Future<void> _onAuthInit(AuthInitEvent event, Emitter<AuthState> emit) async {
    emit(const AuthState.checking());

    // Subscribe to auth state stream
    _repository.authStateStream.listen((user) {
      if (user != null) {
        add(SessionExpiredEvent(user)); // User authenticated
      } else {
        add(SessionExpiredEvent(null)); // User logged out
      }
    });
  }

  Future<void> _onSignUpEmail(
    SignUpEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _repository.signUpWithEmail(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (user) => emit(AuthState.authenticated(user)),
      (failure) => emit(AuthState.error(failure)),
    );
  }

  Future<void> _onSignInEmail(
    SignInEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _repository.signInWithEmail(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (user) => emit(AuthState.authenticated(user)),
      (failure) => emit(AuthState.error(failure)),
    );
  }

  Future<void> _onSignInGoogle(
    SignInGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _repository.signInWithGoogle();

    result.fold(
      (user) => emit(AuthState.authenticated(user)),
      (failure) => emit(AuthState.error(failure)),
    );
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _repository.signOut();

    result.fold(
      (_) => emit(const AuthState.unauthenticated()),
      (failure) => emit(AuthState.error(failure)),
    );
  }

  Future<void> _onSessionExpired(
    SessionExpiredEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (event.user != null) {
      emit(AuthState.authenticated(event.user!));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }
}
```

```dart
// lib/features/auth/presentation/bloc/auth_event.dart
part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthInitEvent extends AuthEvent {
  const AuthInitEvent();
}

class SignUpEmailEvent extends AuthEvent {
  final String email;
  final String password;

  const SignUpEmailEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignInEmailEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEmailEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignInGoogleEvent extends AuthEvent {
  const SignInGoogleEvent();
}

class SignOutEvent extends AuthEvent {
  const SignOutEvent();
}

class SessionExpiredEvent extends AuthEvent {
  final User? user;

  const SessionExpiredEvent(this.user);

  @override
  List<Object?> get props => [user];
}
```

```dart
// lib/features/auth/presentation/bloc/auth_state.dart
part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.checking() = _Checking;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(AuthFailure failure) = _Error;
}
```

---

## Step 4: Router Guards

```dart
// lib/config/router/guards/auth_guard.dart
import 'package:auto_route/auto_route.dart';
import 'package:go_question/features/auth/presentation/bloc/auth_bloc.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final authBloc = router.navigatorObservers.first is AuthBloc
        ? router.navigatorObservers.first as AuthBloc
        : null;

    if (authBloc != null && authBloc.state is AuthenticatedState) {
      resolver.next(true);
    } else {
      resolver.redirect(const LoginRoute());
    }
  }
}

// lib/config/router/guards/guest_guard.dart
class GuestGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final authBloc = router.navigatorObservers.first is AuthBloc
        ? router.navigatorObservers.first as AuthBloc
        : null;

    if (authBloc == null || authBloc.state is! AuthenticatedState) {
      resolver.next(true);
    } else {
      resolver.redirect(const HomeRoute());
    }
  }
}
```

---

## Step 5: Critical Tests

```dart
// test/features/auth/domain/repositories/auth_repository_test.dart
void main() {
  group('AuthRepository', () {
    late MockFirebaseAuthDataSource mockDataSource;
    late AuthRepositoryImpl repository;

    setUp(() {
      mockDataSource = MockFirebaseAuthDataSource();
      repository = AuthRepositoryImpl(mockDataSource);
    });

    test('signUpWithEmail returns User on success', () async {
      final mockFBUser = Mock​FirebaseUser();
      when(mockFBUser.uid).thenReturn('user123');
      when(mockFBUser.email).thenReturn('test@example.com');
      when(mockFBUser.emailVerified).thenReturn(false);

      final mockCredential = MockUserCredential();
      when(mockCredential.user).thenReturn(mockFBUser);

      when(mockDataSource.signUpWithEmail(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => mockCredential);

      final result = await repository.signUpWithEmail(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result.isSuccess, true);
      expect(result.getOrNull()?.id, 'user123');
    });

    test('signUpWithEmail returns failure on duplicate email', () async {
      when(mockDataSource.signUpWithEmail(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(EmailAlreadyInUseException('Email already in use'));

      final result = await repository.signUpWithEmail(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result.isFailure, true);
      expect(
        result.getErrorOrNull(),
        isA<AuthFailure>(),
      );
    });

    test('signOut clears user', () async {
      when(mockDataSource.signOut()).thenAnswer((_) async {});

      final result = await repository.signOut();

      expect(result.isSuccess, true);
      verify(mockDataSource.signOut()).called(1);
    });
  });
}
```

```dart
// test/features/auth/presentation/bloc/auth_bloc_test.dart
void main() {
  group('AuthBloc', () {
    late MockAuthRepository mockRepository;
    late AuthBloc bloc;

    setUp(() {
      mockRepository = MockAuthRepository();
      bloc = AuthBloc(mockRepository);
    });

    blocTest<AuthBloc, AuthState>(
      'emit loading then authenticated on SignUpEmailEvent success',
      build: () {
        final mockUser = User(
          id: 'user123',
          email: 'test@example.com',
          createdAt: DateTime.now(),
          emailVerified: false,
        );

        when(mockRepository.signUpWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => Result.success(mockUser));

        return bloc;
      },
      act: (bloc) => bloc.add(
        const SignUpEmailEvent(
          email: 'test@example.com',
          password: 'password123',
        ),
      ),
      expect: () => [
        isA<LoadingState>(),
        isA<AuthenticatedState>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emit error on weak password',
      build: () {
        when(mockRepository.signUpWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer(
          (_) async => Result.failure(AuthFailure.weakPassword()),
        );

        return bloc;
      },
      act: (bloc) => bloc.add(
        const SignUpEmailEvent(
          email: 'test@example.com',
          password: '123',
        ),
      ),
      expect: () => [
        isA<LoadingState>(),
        isA<ErrorState>(),
      ],
    );
  });
}
```

---

## Security Checklist

Before shipping auth to production:

- [ ] **Secrets**: No hardcoded Firebase keys in code (use `google-services.json` + `.gitignore`)
- [ ] **Storage**: No plaintext tokens in `shared_preferences` (use Firebase Session Cookies)
- [ ] **Session**: Clear local auth state on sign-out
- [ ] **Verification**: Require email verification before privileged actions
- [ ] **Rate limiting**: Implement login attempt rate limiting
- [ ] **Password**: Enforce strong password rules (min 8 chars, complexity)
- [ ] **Google Sign-In**: Configure OAuth 2.0 redirect URIs correctly
- [ ] **Firestore rules**: Add rules preventing user from accessing other users' data
- [ ] **Token refresh**: Implement token refresh on 401 responses
- [ ] **Audit**: Log auth events (sign-up, sign-in, failures) without sensitive data

---

## Deployment Checklist

- [ ] Firebase Auth enabled in Firebase Console
- [ ] Email/password provider enabled
- [ ] Google Sign-In provider configured
- [ ] OAuth 2.0 client IDs created (Android + iOS)
- [ ] `google-services.json` in `android/app/`
- [ ] GoogleService-Info.plist` in `ios/Runner/`
- [ ] Domain auth repository registered in DI
- [ ] Auth BLoC added to main app widget
- [ ] Route guards configured
- [ ] All tests passing
- [ ] `flutter analyze` passes
- [ ] Security review completed

---

## References

- [Firebase Auth Docs](https://firebase.google.com/docs/auth)
- [firebase_auth Pub](https://pub.dev/packages/firebase_auth)
- [Google Sign-In Pub](https://pub.dev/packages/google_sign_in)
- Project: [.agents/rules/security.md](../../.agents/rules/security.md)
- Project: [.agents/harness/10_architecture_guardrails.md](../../.agents/harness/10_architecture_guardrails.md)

---

**Last updated**: 2026-04-08
