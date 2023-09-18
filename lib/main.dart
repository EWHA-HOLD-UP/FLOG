import 'package:flog/providers/user_provider.dart';
import 'package:flog/screen/floging/floging_screen.dart';
import 'package:flog/screen/splash_screen.dart';
import 'package:flog/screen/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flog/screen/register/sms_login_home.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';
import 'models/model_auth.dart';
import 'screen/register/login_screen.dart';
import 'screen/register/register_screen.dart';
import 'package:flog/notification/scheduling.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Firebase 초기화 코드

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
    '1',
    'simpleTask',
    initialDelay: Duration(minutes: 1), // 초기 딜레이 설정
    frequency: Duration(minutes: 1), // 주기 설정
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          //프로바이더 추가 가능
          ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: MaterialApp(
          title: 'Flog',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/index': (context) => const FlogingScreen(),
          },
        ));
  }
}
