import 'package:flutter/material.dart';
import 'package:flog/screen/profile/profile_edit_screen.dart';
import 'package:flog/screen/profile/setting_screen.dart';
import 'package:flog/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flog/utils/util.dart';


class ProfileScreen extends StatefulWidget {
  // 유저 프로필 표시를 위해 필요한 생성자 작성해야함
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;

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
        ], // 그림자 제거
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection("User").doc(currentUser.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // 데이터가 로드될 때까지 로딩 표시기 표시
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            if (snapshot.data == null || !snapshot.data!.exists) {
              return Text('데이터 없음 또는 문서가 없음'); // Firestore 문서가 없는 경우 또는 데이터가 null인 경우 처리
            }
            // 이제 snapshot.data을 안전하게 사용할 수 있음
            Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
            // 데이터 처리
            return Padding(
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
                                        builder: (
                                            context) => const ProfileEditScreen(),
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
                    Text(userData['nickname'],
                        style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold,)),
                    //여기에 user.nickname 값 불러오기
                    Text(userData['email'], style: TextStyle(fontSize: 20,)),
                    //여기에 user.uid 값 불러오기
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
            );
          }
        }
    ),
    );

// 메서드 위젯 추가
  }
}
