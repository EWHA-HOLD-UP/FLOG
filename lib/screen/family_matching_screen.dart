import 'package:flog/screen/matching_code_entering_screen.dart';
import 'package:flog/screen/waiting_for_family.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class FamilyMatchingScreen extends StatefulWidget {
  final String nickname;
  const FamilyMatchingScreen({required this.nickname, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FamilyMatchingScreenState();
}

class _FamilyMatchingScreenState extends State<FamilyMatchingScreen> {
  late String familycode;

  @override
  void initState() {
    super.initState();
    getFamilyCode();
  }

  Future<void> getFamilyCode() async {
    var random = Random();
    var leastcharindex=[]; //꼭 들어가야 할 문자
    var skipCharacter = [ //포함하지 않은 문자
      0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F,
      0x40, 0x5B, 0x5C, 0x5D, 0x5E, 0x5F, 0x60
    ];
    var min = 0x30; //사용할 아스키 문자 시작
    var max = 0x7A; //사용할 아스키 문자 마지막
    var code = []; //생성한 코드

    while(code.length <= 15) { //가족 코드는 15글자
      var tmp = min + random.nextInt(max - min); //랜덤으로 아스키 값 받기
      if(skipCharacter.contains(tmp)){
        continue;
      }
      code.add(tmp);
    }

    while(leastcharindex.length < 3) { //특수문자, 숫자, 문자 섞기 위해 하나씩 지정하여 꼭 넣기
      var ran = random.nextInt(15);
      if(!leastcharindex.contains(ran)) {
        leastcharindex.add(ran);
      }
    }
    code[leastcharindex[0]] = 0x21; //!
    code[leastcharindex[1]] = 0x78; //x
    code[leastcharindex[2]] = 0x30; //0

    String generatedCode = String.fromCharCodes(code.cast<int>());

    setState(() {
      familycode = generatedCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child:
        Scaffold(
          body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text('가족 연결',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 140),
                  Image.asset(
                    "assets/flog_logo.png",
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 30),
                  Text('생성된 FLOG 코드',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  SizedBox(height:5),
                  Text('$familycode',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: familycode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${widget.nickname}님의 가족 코드가 복사되었습니다!'),
                          duration: Duration(seconds: 3), // 알림이 화면에 표시될 시간 2초
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WaitingForFamily(familycode: familycode)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Colors.white,
                      minimumSize: Size(300, 50),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Text(
                      'FLOG 코드 공유',
                      style: TextStyle(
                        color: Color(0xFF609966),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MatchingCodeEnteringScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Color(0xFF609966),
                      minimumSize: Size(300, 50), // 버튼의 최소 크기 설정 (가로 200, 세로 50)
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 내부 패딩 설정
                    ),
                    child: Text(
                      'FLOG 코드 입력',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ]
              ),
            ),
          ),
        ),
    );
  }
}