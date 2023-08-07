import 'package:flutter/material.dart';

class FlogingDetailScreen extends StatelessWidget {

  final String status; // 전달받은 상태 정보 저장
  const FlogingDetailScreen({required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 앱바 배경 색상
        elevation: 0, // 그림자 제거
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black, // 뒤로가기 버튼 아이콘 색상
          ),
          onPressed: () {
            // 뒤로가기 버튼 클릭 시 이전 페이지(Floging_Screen)로 이동
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            Image.asset(
              "assets/flog_logo.png",
              width: 55,
              height: 55,
            ),
            Text(
              "FLOGing",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xFF609966),
              ),
            ),
            SizedBox(height: 20), // 간격
            Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                color: Color(0xad747474),
                borderRadius: BorderRadius.circular(23), // 모서리 둥글기 조절
              ),
              child: Center(
                child: Text(
                  status,
                  style: TextStyle(fontSize: 20, color: Colors.white),

                ),
              ),
            ),
            // 이곳에 추가적인 상세 정보를 표시하는 위젯을 추가
          ],
        ),
      ),
      ),
    );
  }
}
