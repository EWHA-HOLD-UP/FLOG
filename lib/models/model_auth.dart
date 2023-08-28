// 인증 관련 기능 처리를 위한 모델

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flog/models/user.dart' as model;
import 'package:uuid/uuid.dart';

import '../providers/user_provider.dart';

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
            flogCode: "null",
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

  // 그룹에 유저 등록하기
  Future<void> registerGroup(String flogCode, String uid) async {
    final CollectionReference groupRef =
        FirebaseFirestore.instance.collection('groups');
    DocumentSnapshot docSnapshot = await groupRef.doc(flogCode).get();

    if (docSnapshot.exists) {
      // 그룹이 존재하는 경우 -> 그룹에 추가하기
      List<dynamic> currentMembers = docSnapshot.get('members');
      await groupRef.doc(flogCode).update({
        'members': FieldValue.arrayUnion(uid as List),
        'memNumber': currentMembers.length + 1
      });
    } else {
      // 그룹이 존재하지 않는 경유 -> 그룹 생성하기
      model.Group group = model.Group(
          flogCode: flogCode, members: [uid], frog: 0, memNumber: 1);
      await _firestore.collection("Group").doc(flogCode).set(group.toJson());
    }
  }
}
