// user의 상태를 관리하는 provider
import 'package:flutter/material.dart';
import 'package:flog/models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user; //현재 사용자의 정보를 가지는 User 객체

  User get getUser => _user!; //_user의 값을 가져오는 getter 메서드

  void updateUser(User newUser) {
    _user = newUser; //새로운 User 객체를 인자로 받아 _user를 업데이트
    notifyListeners(); // 상태 변화 알림
  }
}