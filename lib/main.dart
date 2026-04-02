import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_question/go_question_app.dart';

import 'firebase_options.dart';
import 'injection_container/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await di.init();

  runApp(const GoQuestionApp());
}
