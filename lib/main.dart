import 'package:flog/screen/floging/shooting_screen_back.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flog/screen/register/start_login_screen.dart';
import 'package:flog/screen/register/personal_nickname_screen.dart';
import 'package:flog/screen/register/sms_login_home.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Firebase 초기화 코드

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/init',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const NicknameScreen(),
        '/init': (context) => const LoginScreen(),
      },
    );
  }
}
