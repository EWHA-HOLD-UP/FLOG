import 'package:flog/screen/login_screen.dart';
<<<<<<< Updated upstream
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
=======
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: '087583fc09c32aabab81836a3f188bab');
  //Firebase 초기화 코드

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MaterialApp(
      home: LoginScreen(),
>>>>>>> Stashed changes
    ),
  );
}
