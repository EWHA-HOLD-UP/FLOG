import 'package:flutter/material.dart';

class ProfileEditScreen extends StatefulWidget {
  // 유저 프로필 표시를 위해 필요한 생성자 작성해야함
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {

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
        title: const Text('프로필 수정',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold, // 굵게 설정
          ),
        ),
        backgroundColor: Colors.transparent, // 투명 설정
        elevation: 0, // 그림자 제거
      ),
      body: Center(
        child: Text('위젯 추가해야해요'),
      ),
    );
  }

// 메서드 위젯 추가
}