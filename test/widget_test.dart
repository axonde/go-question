// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:go_question/main.dart';
// import 'package:go_question/features/auth/domain/repositories/i_auth_repository.dart';
// import 'package:go_question/core/network/network_info.dart';

// // Простые заглушки для теста
// class FakeAuthRepository extends Fake implements IAuthRepository {}
// class FakeNetworkInfo extends Fake implements NetworkInfo {}

// void main() {
//   testWidgets('App load test', (WidgetTester tester) async {
//     // Просто проверяем, что конструктор MyApp вызывается без ошибок
//     await tester.pumpWidget(MyApp(
//       authRepository: FakeAuthRepository() as dynamic,
//       networkInfo: FakeNetworkInfo(),
//     ));

//     expect(find.byType(MaterialApp), findsOneWidget);
//   });
// }
