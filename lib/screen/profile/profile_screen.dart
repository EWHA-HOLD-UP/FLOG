import 'package:flutter/material.dart';
import 'package:flog/screen/profile/profile_edit_screen.dart';
import 'package:flog/screen/profile/setting_screen.dart';

class ProfileScreen extends StatefulWidget {
  // 유저 프로필 표시를 위해 필요한 생성자 작성해야함
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold, // 굵게 설정
          ),
        ),
        backgroundColor: Colors.transparent, // 투명 설정
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings, // 프로필 편집 아이콘
              color: Colors.black, // 아이콘 색상
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingScreen(),
                ),
              );
            },
          ),
        ],// 그림자 제거
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Hero(
                  tag: "profile",
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffD9D9D9),
                        ),
                      ),
                      Positioned(
                        bottom: 0, // 아래쪽에 위치
                        right: 0, // 오른쪽에 위치
                        child: IconButton(
                          icon: Image.asset(
                            'button/edit.png',
                            width: 30,
                            height: 30,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileEditScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )

              ),
              ),
            const SizedBox(height: 10),
            const Text("현서", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,)), //여기에 user.nickname 값 불러오기
            const Text("tocputer", style: TextStyle(fontSize: 20,)),//여기에 user.uid 값 불러오기
            const SizedBox(height: 200),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("위젯 추가해야해요", style: TextStyle(fontSize: 15)),
                SizedBox(width: 5),
              ],
                 )
              ]
    ),
      ),
    );
  }

// 메서드 위젯 추가
}
