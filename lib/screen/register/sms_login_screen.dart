import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flog/models/user.dart' as flog_User;

class SMSLoginPage extends StatefulWidget {
  const SMSLoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _SMSLoginPageState();
}

class _SMSLoginPageState extends State<SMSLoginPage> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();
  bool _codeSent = false;
  late String _verificationId;

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
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Form(
            key: _key,
            child: Column(
              mainAxisSize: MainAxisSize.min, //column의 세로축
              children: [
                phoneNumberInput(),
                const SizedBox(height: 15),
                _codeSent ? const SizedBox.shrink() : submitButton(),
                const SizedBox(height: 15),
                loginButton(),
                const SizedBox(height: 15),
                _codeSent ? smsCodeInput() : const SizedBox.shrink(),
                const SizedBox(height: 15),
                _codeSent ? verifyButton() : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField phoneNumberInput() {
    return TextFormField(
      controller: _phoneController,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return '비어있음';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: '핸드폰 번호를 입력하세요.', //+8210 넣고 입력해야됨
        hintStyle: TextStyle(
            color: Colors.black12, fontSize: 25, fontStyle: FontStyle.italic),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF609966)),
        ),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
      ),
    );
  }

  TextFormField smsCodeInput() {
    return TextFormField(
      controller: _smsCodeController,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return '입력되지 않음';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: '전송 받은 sms 코드를 입력하세요.',
        hintStyle: TextStyle(
            color: Colors.black12,
            fontWeight: FontWeight.w900,
            fontSize: 25,
            fontStyle: FontStyle.italic),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF609966)),
        ),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
      ),
    );
  }

  ElevatedButton submitButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_key.currentState!.validate()) {
          FirebaseAuth auth = FirebaseAuth.instance;
          await auth.verifyPhoneNumber(
            phoneNumber: _phoneController.text,
            verificationCompleted: (PhoneAuthCredential credential) async {
              await auth
                  .signInWithCredential(credential)
                  .then((_) => Navigator.pushNamed(context, "/"));
            },
            verificationFailed: (FirebaseAuthException e) {
              if (e.code == 'invalid-phone-number') {
                print('올바르지 않은 핸드폰 번호입니다.');
              }
            },
            codeSent: (String verificationId, forceResendingToken) async {
              String smsCode = _smsCodeController.text;
              setState(() {
                _codeSent = true;
                _verificationId = verificationId;
              });
            },
            codeAutoRetrievalTimeout: (verificationId) {
              print("handling code auto retrieval timeout");
            },
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF609966), // 버튼 배경색을 원하는 색상으로 변경
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // 버튼의 모서리를 둥글게 조정
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        color: const Color(0xFF609966),
        child: const Text(
          "SMS 코드 전송",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  ElevatedButton loginButton() {
    return ElevatedButton(
      onPressed: () async {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF609966), // 버튼 배경색을 원하는 색상으로 변경
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // 버튼의 모서리를 둥글게 조정
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        color: const Color(0xFF609966),
        child: const Text(
          "로그인",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  ElevatedButton verifyButton() {
    return ElevatedButton(
      onPressed: () async {
        FirebaseAuth auth = FirebaseAuth.instance;
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: _verificationId, smsCode: _smsCodeController.text);
        await auth
            .signInWithCredential(credential)
            .then((_) => Navigator.pushNamed(context, "/"));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF609966), // 버튼 배경색을 원하는 색상으로 변경
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // 버튼의 모서리를 둥글게 조정
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        color: const Color(0xFF609966),
        child: const Text(
          "확인",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
