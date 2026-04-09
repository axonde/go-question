import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/core/services/sfx_service.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/features/auth/domain/entities/auth_page.dart';
import 'package:go_question/features/auth/domain/entities/registration_input_entity.dart';
import 'package:go_question/features/auth/domain/errors/auth_failure.dart';
import 'package:go_question/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:go_question/features/auth/domain/services/auth_page_memory.dart';
import 'package:go_question/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_question/features/settings/presentation/pages/settings_page.dart';
import 'package:go_question/injection_container/injection_container.dart';
import 'package:mocktail/mocktail.dart';

class MockSfxService extends Mock implements SfxService {}

class FakeAuthRepository implements IAuthRepository {
  RegistrationInput? _currentUser;
  bool _isEmailVerified;

  FakeAuthRepository({
    RegistrationInput? currentUser,
    bool isEmailVerified = true,
  }) : _currentUser = currentUser,
       _isEmailVerified = isEmailVerified;

  @override
  RegistrationInput? getCurrentUser() => _currentUser;

  @override
  bool isCurrentUserEmailVerified() => _isEmailVerified;

  @override
  Stream<String?> get authStateChanges async* {
    yield _currentUser?.uid;
  }

  @override
  Future<Result<Null, AuthFailure>> deleteCurrentUser() async {
    _currentUser = null;
    _isEmailVerified = false;
    return const Success<Null, AuthFailure>(null);
  }

  @override
  Future<Result<bool, AuthFailure>> checkEmailVerified() async {
    return Success<bool, AuthFailure>(_isEmailVerified);
  }

  @override
  Future<Result<RegistrationInput?, AuthFailure>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return Success<RegistrationInput?, AuthFailure>(_currentUser);
  }

  @override
  Future<Result<String, AuthFailure>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String nickname,
  }) async {
    _currentUser = RegistrationInput(
      uid: 'uid-1',
      nickname: nickname,
      email: email,
      password: password,
    );
    _isEmailVerified = false;
    return Success<String, AuthFailure>(email);
  }

  @override
  Future<Result<RegistrationInput?, AuthFailure>> signInWithGoogle() async {
    return Success<RegistrationInput?, AuthFailure>(_currentUser);
  }

  @override
  Future<Result<Null, AuthFailure>> sendEmailVerification() async {
    return const Success<Null, AuthFailure>(null);
  }

  @override
  Future<Result<Null, AuthFailure>> signOut() async {
    _currentUser = null;
    _isEmailVerified = false;
    return const Success<Null, AuthFailure>(null);
  }
}

class InMemoryAuthPageMemory implements AuthPageMemory {
  AuthPage _page = AuthPage.login;

  @override
  Future<AuthPage> readLastPage() async => _page;

  @override
  Future<void> saveLastPage(AuthPage page) async {
    _page = page;
  }
}

void main() {
  setUp(() async {
    await sl.reset();
    final mockSfxService = MockSfxService();
    when(() => mockSfxService.playTap()).thenAnswer((_) async {});
    sl.registerLazySingleton<SfxService>(() => mockSfxService);
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('logout from settings resets auth bloc state', (tester) async {
    final repo = FakeAuthRepository(
      currentUser: const RegistrationInput(
        uid: 'uid-1',
        nickname: 'alice_1',
        email: 'alice@example.com',
      ),
    );
    final pageMemory = InMemoryAuthPageMemory();
    final bloc = AuthBloc(repo, pageMemory);

    addTearDown(bloc.close);

    bloc.add(const AuthStarted());
    await tester.pump();
    await tester.pump();

    expect(bloc.state.status, AuthStatus.awaitingProfile);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: bloc, child: const SettingsPage()),
      ),
    );

    final signOutFinder = find.byType(GQButton).first;
    await tester.ensureVisible(signOutFinder);
    await tester.tap(signOutFinder);
    await tester.pump();
    await tester.pump();

    expect(bloc.state.status, AuthStatus.unauthenticated);
    expect(bloc.state.user, isNull);
    expect(bloc.state.verificationEmail, isNull);
    expect(bloc.state.hint, isNull);
    expect(bloc.state.errorMessage, isNull);
    expect(bloc.state.currentPage, AuthPage.login);
    expect(bloc.state.loginEmail, isEmpty);
    expect(bloc.state.signUpNickname, isEmpty);
  });
}
