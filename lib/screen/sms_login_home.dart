import 'package:firebase_auth/firebase_auth.dart';
import 'package:flog/screen/kakao_login_screen.dart';
import 'package:flog/screen/nickname_screen.dart';
import 'package:flog/screen/sms_login_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext con, AsyncSnapshot<User?> user) {
          if (!user.hasData) {
            print("인증 실패");
            return NicknameScreen();
          } else {
            print("인증");
            return Scaffold(
              appBar: AppBar(
                title: const Text("FLOG"),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async => await FirebaseAuth.instance
                        .signOut()
                        .then((_) => Navigator.pushNamed(context, "/")),
                  ),
                ],
                backgroundColor: Colors.white12,
                elevation: 0.0,
                leading: IconButton(
                  icon: Image.asset('button/back_arrow.png',
                      width: 20, height: 20),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: const Center(
                child: Text('성공적으로 로그인되었습니다!'),
              ),
            );
          }
        });
  }
}
