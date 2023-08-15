import 'package:flog/screen/floging/floging_screen.dart';
import 'package:flog/screen/floging/shooting_screen_back.dart';
import 'package:flog/screen/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flog/screen/register/start_login_screen.dart';
import 'package:flog/screen/register/personal_nickname_screen.dart';
import 'package:flog/screen/register/sms_login_home.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'models/model_auth.dart';
import 'screen/register/login_screen.dart';
import 'screen/register/register_screen.dart';

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
    return MultiProvider(
        providers: [
          //프로바이더 추가 가능
          ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
        ],
        child: MaterialApp(
          title: 'Flog',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/login',
          routes: {
            '/': (context) => const HomePage(),
            '/login': (context) => LoginScreen1(),
            '/register': (context) => RegisterScreen(),
            '/index': (context) => const FlogingScreen(),
          },
        ));
  }
}
