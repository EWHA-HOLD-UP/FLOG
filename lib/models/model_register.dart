// 회원가입 입력 필드 처리를 위한 모델

import 'package:flutter/material.dart';

class RegisterFieldModel extends ChangeNotifier {
  String email = "";
  String password = "";
  String passwordConfirm = "";

  void setEmail(String Email) {
    this.email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  void setPasswordConfirm(String passwordConfirm) {
    this.passwordConfirm = passwordConfirm;
    notifyListeners();
  }
}
