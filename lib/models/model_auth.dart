// 인증 관련 기능 처리를 위한 모델

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flog/models/user.dart' as model;

enum AuthStatus {
  registerSuccess,
  registerFail,
  loginSuccess,
  loginFail,
}

class FirebaseAuthProvider with ChangeNotifier {
  FirebaseAuth authClient;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;

  FirebaseAuthProvider({auth}) : authClient = auth ?? FirebaseAuth.instance;

  Future<AuthStatus> registerWithEmail(
      String email, String password, String nickname, String birth) async {
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          nickname.isNotEmpty ||
          birth.isNotEmpty) {
        UserCredential credential =
            await authClient.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        model.User user = model.User(
            uid: credential.user!.uid,
            email: email,
            birth: birth,
            nickname: nickname,
            flogCode: "",
            profile: "1",
            isAnswered: false,
            isUpload: false);

        // 데이터베이스에 저장
        await _firestore
            .collection("User")
            .doc(credential.user!.uid)
            .set(user.toJson());

        return AuthStatus.registerSuccess;
      } else {
        return AuthStatus.registerFail;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return AuthStatus.registerFail;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return AuthStatus.registerFail;
      }
    } catch (e) {
      print(e);
      return AuthStatus.registerFail;
    }
    return AuthStatus.registerFail;
  }

  Future<AuthStatus> loginWithEmail(String email, String password) async {
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await authClient
            .signInWithEmailAndPassword(email: email, password: password)
            .then((credential) async {
          user = credential.user;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLogin', true);
          prefs.setString('email', email);
          prefs.setString('password', password);
        });
        print("[+] 로그인 유저 : ${user!.email}");
        return AuthStatus.loginSuccess;
      } else {
        return AuthStatus.loginFail;
      }
    } catch (e) {
      print(e);
      return AuthStatus.loginFail;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', false);
    prefs.setString('email', '');
    prefs.setString('password', '');
    user = null;
    await authClient.signOut();
    print("[-] 로그아웃");
  }
}
