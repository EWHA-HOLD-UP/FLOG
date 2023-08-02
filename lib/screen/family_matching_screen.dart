import 'package:flog/screen/matching_code_entering_screen.dart';
import 'package:flutter/material.dart';

class FamilyMatchingScreen extends StatelessWidget {
  const FamilyMatchingScreen({Key? key}) : super(key: key);

  final String familycode = "alxlsk203lx";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onPressed: () {},
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
    );
  }
}