import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flog/models/user.dart' as flog_User;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flog/screen/register/matching_screen.dart';

class BirthScreen extends StatefulWidget {
  final String nickname;
  const BirthScreen({required this.nickname, Key? key}) : super(key: key);
  @override
  State<BirthScreen> createState() => _BirthScreenState();
}

class _BirthScreenState extends State<BirthScreen> {
  TextEditingController birthController = TextEditingController();
  bool isButtonEnabled = false; //'다음' 버튼 비활성화

  @override
  void dispose() {
    birthController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    updateButtonStatus();
  }

  void updateButtonStatus() {
    //글자가 4개 입력되면 '다음' 버튼 활성화
    setState(() {
      isButtonEnabled = birthController.text.length == 4;
    });
  }

  //다음 화면으로 넘어가기 전 키보드 숨기기 - 이 코드 없으면 공사장 표시 잠시 나타남
  void dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //뒤로가기 방지
      onWillPop: () async => false,
      child: Scaffold(
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
          child: Column(
            children: [
              SizedBox(height: 50),
              Row(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(width: 20),
                  Image.asset("assets/flog_logo.png", width: 40, height: 40),
                  SizedBox(width: 5),
                  Text(
                    '${widget.nickname}님의 생일을 입력해주세요.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ]),
              ]),
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      width: 340,
                      child: TextField(
                        maxLength: 4,
                        onChanged: (value) {
                          updateButtonStatus();
                        },
                        controller: birthController,
                        keyboardType: TextInputType.number, //숫자 키보드
                        decoration: InputDecoration(
                            hintText: 'MMDD(ex. 10월 2일 : 1002)',
                            hintStyle: TextStyle(
                                color: Colors.black12,
                                fontWeight: FontWeight.w900,
                                fontSize: 25,
                                fontStyle: FontStyle.italic),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF609966)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black26)),
                            helperText: '4개의 숫자를 입력해주세요.'),
                      ),
                    ),
                    SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                              dismissKeyboard(); // 키보드 숨기기

                              String entered_nickname = widget
                                  .nickname; //닉네임 저장된 변수 - 파이어베이스에 저장 + 셋팅 화면에서 활용하면 될 것 같음
                              String entered_birth = birthController.text;

                              /* 하단 두개 변수를 파이어베이스에 저장 + 셋팅 화면에서 활용하면 될 것 같음 */
                              String entered_birth_month =
                                  entered_birth.substring(0, 2); //월 저장된 변수
                              String entered_birth_day =
                                  entered_birth.substring(2); //일 저장된 변수
                              // print('$entered_birth_month 월 $entered_birth_day 일'); 잘 분리되어 저장된 것 확인 완료

                              //파이어베이스에 유저정보 저장하기!!!!
                              FirebaseFirestore db = FirebaseFirestore.instance;
                              CollectionReference userRef =
                                  db.collection("Users");

                              flog_User.User user = flog_User.User(
                                  uid: 'flog_User.getCurrentUserUID()',
                                  nickname: entered_nickname,
                                  birth:
                                      entered_birth_month + entered_birth_day,
                                  profile: 'null',
                                  flogCode: 'null',
                                  isUpload: false,
                                  isAnswered: false);

                              flog_User.save(userRef, user);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FamilyMatchingScreen(
                                              nickname: entered_nickname)));
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Color(0xFF609966),
                        minimumSize: Size(300, 50),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Text(
                        '다음',
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
            ],
          ),
        ),
      ),
    );
  }
}
