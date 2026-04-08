import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/auth/domain/entities/auth_page.dart';
import 'package:go_question/features/auth/domain/entities/registration_input_entity.dart';
import 'package:go_question/features/auth/domain/errors/auth_failure.dart';
import 'package:go_question/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:go_question/features/auth/domain/services/auth_page_memory.dart';
import 'package:go_question/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_question/features/auth/presentation/pages/auth_flow_page.dart';

class _FakeAuthRepository implements IAuthRepository {
  RegistrationInput? _currentUser;
  bool _isEmailVerified;

  _FakeAuthRepository({
    RegistrationInput? currentUser,
    bool isEmailVerified = false,
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
  Future<Result<bool, AuthFailure>> checkEmailVerified() async {
    return Success<bool, AuthFailure>(_isEmailVerified);
  }

  @override
  Future<Result<Null, AuthFailure>> deleteCurrentUser() async {
    _currentUser = null;
    _isEmailVerified = false;
    return const Success<Null, AuthFailure>(null);
  }

  @override
  Future<Result<Null, AuthFailure>> signOut() async {
    _currentUser = null;
    _isEmailVerified = false;
    return const Success<Null, AuthFailure>(null);
  }
}

class _InMemoryAuthPageMemory implements AuthPageMemory {
  AuthPage _page = AuthPage.signUp;

  @override
  Future<AuthPage> readLastPage() async => _page;

  @override
  Future<void> saveLastPage(AuthPage page) async {
    _page = page;
  }
}

void main() {
  testWidgets(
    'AuthFlowPage updates shared AuthBloc state on sign up form changes',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final repo = _FakeAuthRepository();
      final pageMemory = _InMemoryAuthPageMemory();
      final bloc = AuthBloc(repo, pageMemory);

      addTearDown(bloc.close);

      bloc.add(const AuthStarted());
      await tester.pump();
      await tester.pump();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: bloc,
            child: const AuthFlowPage(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, 'Alice');
      await tester.pump();

      expect(bloc.state.signUpNickname, 'Alice');
    },
  );
}
