import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_question/core/network/network_info.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:go_question/features/auth/data/source/datasource.dart';
import 'package:go_question/features/auth/domain/errors/auth_exception_to_failure_mapper.dart';
import 'package:go_question/features/auth/domain/errors/auth_failure.dart';
import 'package:go_question/features/auth/domain/entities/registration_input_entity.dart';

class MockAuthRemoteDataSource extends Mock implements IAuthRemoteDataSource {}
class MockAuthExceptionToFailureMapper extends Mock
    implements AuthExceptionToFailureMapper {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthExceptionToFailureMapper mockErrorMapper;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockErrorMapper = MockAuthExceptionToFailureMapper();
    mockNetworkInfo = MockNetworkInfo();

    repository = AuthRepositoryImpl(
      mockRemoteDataSource,
      mockErrorMapper,
      mockNetworkInfo,
    );
  });

  group('Network protection in AuthRepositoryImpl', () {
    test(
        'должен возвращать AuthFailure.network(), когда нет интернета, '
        'и не должен вызывать Firebase DataSource', () async {
      // Возвращаем false (нет интернета)
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Пытаемся залогиниться
      final result = await repository.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      // 1. Проверяем, что запрос к NetworkInfo произошел
      verify(() => mockNetworkInfo.isConnected).called(1);
      
      // 2. Проверяем, что к Firebase (RemoteDataSource) НЕ обращались
      verifyZeroInteractions(mockRemoteDataSource);

      // 3. Проверяем, что вернулась именно ошибка сети (Result.Failure)
      expect(result, isA<Failure<RegistrationInput?, AuthFailure>>());
      final failure = (result as Failure).failure as AuthFailure;
      expect(failure.type, equals(AuthFailureType.network));
    });

    test('должен делать вызов в RemoteDataSource, когда интернет ЕСТЬ',
        () async {
      // Возвращаем true (интернет есть)
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      
      // Делаем заглушку (мок) ответа от Firebase
      final tUser = RegistrationInput(uid: '123', email: 'test@example.com', name: 'Test User');
      when(() => mockRemoteDataSource.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => tUser);

      // Проводим регистрацию
      final result = await repository.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      // Проверяем, что дошли до Firebase Network call
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockRemoteDataSource.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).called(1);

      // Ждем успешный результат с заглушкой tUser
      expect(result, isA<Success<RegistrationInput?, AuthFailure>>());
      final success = (result as Success).value;
      expect(success, equals(tUser));
    });
  });
}
