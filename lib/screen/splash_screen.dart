import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flog/notification/local_notification.dart';
import 'package:flog/screen/register/login_screen.dart';
import 'package:flog/screen/register/matching_screen.dart';
import 'package:flog/screen/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:flog/models/model_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/user_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final authClient =
        Provider.of<FirebaseAuthProvider>(context, listen: false);
    bool isLogin = prefs.getBool('isLogin') ?? false;
    print("[*] 로그인 상태 : " + isLogin.toString());
    if (isLogin) {
      String? email = prefs.getString('email');
      String? password = prefs.getString('password');
      print("[*] 저장된 정보로 로그인 재시도");
      await authClient.loginWithEmail(email!, password!).then((loginStatus) {
        if (loginStatus == AuthStatus.loginSuccess) {
          print("[*] 로그인 성공");
        } else {
          print("[*] 로그인 실패");
          isLogin = false;
          prefs.setBool('isLogin', false);
        }
      });
    }
    return isLogin;
  }

  void moveScreen() async {
    await checkLogin().then((isLogin) async {
      if (isLogin) {
        // 유저의 flogCode 가져오기
        final CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('User');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        DocumentSnapshot userDocument =
            await usersCollection.doc(prefs.getString('email')).get();

        if (userDocument.exists) {
          String flogCode = userDocument.get('flogCode');
          if (flogCode == "null") {
            //flogCode가 없는경우(가족 등록 안된 신규 유저)
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text('${prefs.getString('email')}님 환영합니다!')));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FamilyMatchingScreen(
                        nickname: prefs.getString('email')!)));
          } else {
            // flogCode가 있는경우(가족 등록된 기존 유저)
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text('${prefs.getString('email')!}님 환영합니다!')));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RootScreen(matchedFamilycode: flogCode)));
          }
        }
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    LocalNotification.initialize();
    Future.delayed(
        const Duration(seconds: 3), LocalNotification.requestPermission());
    super.initState();
    Timer(Duration(microseconds: 1500), () {
      moveScreen();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}
