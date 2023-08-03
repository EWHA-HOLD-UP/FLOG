import 'package:flog/kakao_login.dart';
import 'package:flog/main_view_model.dart';
import 'package:flog/screen/birth_screen.dart';
import 'package:flog/screen/login_screen.dart';
import 'package:flog/screen/family_matching_screen.dart';
import 'package:flog/screen/nickname_screen.dart';
import 'package:flog/screen/shooting_screen.dart';
import 'package:flog/screen/floging_screen.dart';
import 'package:flog/screen/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'firebase_options.dart';

void main() {
  KakaoSdk.init(nativeAppKey: '087583fc09c32aabab81836a3f188bab');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kakao Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Kakao Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final viewModel = MainViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(
                  viewModel.user?.kakaoAccount?.profile?.profileImageUrl ?? ''),
              Text(
                '${viewModel.isLogined}',
              ),
              ElevatedButton(
                onPressed: () async {
                  await viewModel.login();
                  setState(() {});
                },
                child: const Text('Login'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await viewModel.logout();
                  setState(() {});
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ));
  }
}
