import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flog/models/model_auth.dart';
import 'package:flog/resources/auth_methods.dart';
import 'package:flog/screen/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class MatchingCodeEnteringScreen extends StatefulWidget {
  const MatchingCodeEnteringScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EnteringState();
}

class _EnteringState extends State<MatchingCodeEnteringScreen> {
  TextEditingController codeController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0.0,
        leading: IconButton(
          icon: Image.asset('button/back_arrow.png', width: 20, height: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 70),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const SizedBox(width: 10),
                Image.asset("assets/flog_logo.png", width: 40, height: 40),
                const SizedBox(width: 5),
                const Text(
                  'FLOG 코드를 입력해서 가족을 연결해주세요.',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )
              ]),
              const SizedBox(height: 20),
              SizedBox(
                width: 340,
                child: TextField(
                  controller: codeController,
                  decoration: const InputDecoration(
                      hintText: 'code',
                      hintStyle: TextStyle(
                          color: Colors.black12,
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                          fontStyle: FontStyle.italic),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF609966)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26))),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  String enteredFamilycode = codeController
                      .text; //텍스트 필드에 입력된 가족코드 받아서 저장 - 파이어베이스에 넣을듯
                  if (_auth.currentUser != null) {
                    //그룹 등록하기 -> 작동안됨
                    final authClient = Provider.of<FirebaseAuthProvider>(
                        context,
                        listen: false);
                    authClient.registerGroup(
                        enteredFamilycode, _auth.currentUser!.email!);

                    //유저 정보 flogCode 업데이트 -> 작동안됨
                    AuthMethods().updateUser(_auth.currentUser!.email!,
                        'flogCode', enteredFamilycode);
                  } else {
                    //그룹 등록하기 -> 작동안됨
                    final authClient = Provider.of<FirebaseAuthProvider>(
                        context,
                        listen: false);
                    authClient.registerGroup(
                        enteredFamilycode, "currentUser가 NULL입니다.");

                    //유저 정보 flogCode 업데이트 -> 작동안됨
                    AuthMethods().updateUser(
                        "currentUser가 NULL입니다.", 'flogCode', enteredFamilycode);
                  }

                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        //다음 스크린으로 가족코드 전달되는지 확인 위해 매개변수로 전달
                        builder: (context) =>
                            RootScreen(matchedFamilycode: enteredFamilycode)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: const Color(0xFF609966),
                  minimumSize: const Size(300, 50),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  '완료',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
