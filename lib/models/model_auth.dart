// 인증 관련 기능 처리를 위한 모델

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus {
  registerSuccess,
  registerFail,
  loginSuccess,
  loginFail,
}

class FirebaseAuthProvider with ChangeNotifier {
  FirebaseAuth authClient;
  User? user;

  FirebaseAuthProvider({auth}) : authClient = auth ?? FirebaseAuth.instance;

  Future<AuthStatus> registerWithEmail(
      String email, String password, String nickname, String birth) async {
    try {
      UserCredential credential =
          await authClient.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseFirestore db = FirebaseFirestore.instance;
      CollectionReference userRef = db.collection('User');
      DocumentReference documentRef = await userRef.add({
        'email': email,
        'password': password,
        'nickname': nickname,
        'birth': birth,
        'profle': 'null',
        'flogCode': 'null',
        'isUpload': false,
        'isAnswered': false
      });
      return AuthStatus.registerSuccess;
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
      await authClient
          .signInWithEmailAndPassword(email: email, password: password)
          .then((Credential) async {
        user = Credential.user;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLogin', true);
        prefs.setString('email', email);
        prefs.setString('password', password);
      });
      print("[+] 로그인 유저 : " + user!.email.toString());
      return AuthStatus.loginSuccess;
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
