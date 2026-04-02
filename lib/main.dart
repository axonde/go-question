import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'core/network/network_info.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/source/datasource.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authDataSource = AuthRemoteDataSourceImpl(FirebaseAuth.instance);
  final authRepository = AuthRepositoryImpl(authDataSource);
  final networkInfo = NetworkInfoImpl(InternetConnection());

  runApp(MyApp(authRepository: authRepository, networkInfo: networkInfo));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final NetworkInfo networkInfo;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.networkInfo,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Question',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Container(
        decoration: BoxDecoration(color: Colors.blue),
        child: Center(
          child: GoButton(onPressed: () {}, text: 'privet'),
        ),
      ),
    );
  }
}
