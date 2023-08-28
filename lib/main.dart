import 'package:flog/providers/user_provider.dart';
import 'package:flog/screen/floging/floging_screen.dart';
import 'package:flog/screen/splash_screen.dart';
//import 'package:flog/screen/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
          ChangeNotifierProvider(create: (_) => UserProvider())
        ],
        child: MaterialApp(
          title: 'Flog',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/login',
          routes: {
            '/init': (context) => SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/index': (context) => const FlogingScreen(),
          },
        ));
  }
}
