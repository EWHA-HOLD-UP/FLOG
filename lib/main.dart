import 'package:flog/screen/birth_screen.dart';
import 'package:flog/screen/login_screen.dart';
import 'package:flog/screen/family_matching_screen.dart';
import 'package:flog/screen/nickname_screen.dart';
import 'package:flog/screen/shooting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flog/screen/floging_screen.dart';
import 'package:flog/screen/root_screen.dart';

void main() {
  runApp(
    //Firebase 초기화 코드

    // await Firebase.initializeApp(
    //     options: DefaultFirebaseOptions.currentPlatform,
    // );

    MaterialApp(
      home: NicknameScreen(), //하단탭
    ),
  );
}
