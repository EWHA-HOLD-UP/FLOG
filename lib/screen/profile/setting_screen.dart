import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black, // 뒤로가기 버튼 아이콘 색상
          ),// 이미지 경로 지정
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 기능 추가
          },
        ),
        title: const Text('Setting',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold, // 굵게 설정
          ),
        ),
        backgroundColor: Colors.transparent, // 투명 설정
        elevation: 0, // 그림자 제거
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '일반 설정',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: Icon(Icons.language), // 아이콘 예시
              title: Text('언어 설정'),
              trailing: Icon(Icons.arrow_forward_ios), // 화살표 아이콘 예시
              onTap: () {
                // 언어 설정 화면으로 이동하는 코드를 여기에 추가
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications), // 아이콘 예시
              title: Text('알림 설정'),
              trailing: Icon(Icons.arrow_forward_ios), // 화살표 아이콘 예시
              onTap: () {
                // 알림 설정 화면으로 이동하는 코드를 여기에 추가
              },
            ),
            Divider(), // 분리선 추가

            Text(
              '계정 설정',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: Icon(Icons.security), // 아이콘 예시
              title: Text('보안 설정'),
              trailing: Icon(Icons.arrow_forward_ios), // 화살표 아이콘 예시
              onTap: () {
                // 보안 설정 화면으로 이동하는 코드를 여기에 추가
              },
            ),
            ListTile(
              leading: Icon(Icons.logout), // 아이콘 예시
              title: Text('로그아웃'),
              trailing: Icon(Icons.arrow_forward_ios), // 화살표 아이콘 예시
              onTap: () {
                // 로그아웃 기능을 실행하는 코드를 여기에 추가
              },
            ),
          ],
        ),
      ),
    );
  }
}
