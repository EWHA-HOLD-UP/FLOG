import 'package:flutter/material.dart';
import 'package:flog/screen/profile/profile_edit_screen.dart';
import 'package:flog/screen/profile/setting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  // 유저 프로필 표시를 위해 필요한 생성자 작성해야함
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("User");

  // 프로필 수정하기
  Future<void> editField(String field, String initialValue) async {
    String newValue = initialValue; // 힌트 텍스트로 사용할 초기값 설정
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('닉네임을 수정하시겠어요?',
          style: const TextStyle(color: Colors.black),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: initialValue,
            hintStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff609966), // 활성 상태의 밑줄 색상 변경
            ),
          ),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
      actions: [
        TextButton(
          child: Text(
            '취소',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff609966)),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(
            '저장',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff609966)),
          ),
          onPressed: () => Navigator.of(context).pop(newValue),
        )
      ]
      ),
    );

    //파이어베이스 변경사항 업데이트하기
    if (newValue.trim().length > 0) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }

  }

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
              return const Text('데이터 없음 또는 문서가 없음'); // Firestore 문서가 없는 경우 또는 데이터가 null인 경우 처리
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
                    TextButton(
                        child: Text(userData['nickname'],  style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xff609966))
                        ),
                      onPressed: () => editField('nickname', userData['nickname']),
                       ),
                    //여기에 user.nickname 값 불러오기
                    Text(userData['email'], style: const TextStyle(fontSize: 20,)),
                    //여기에 user.uid 값 불러오기
                    const SizedBox(height: 200),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("위젯 추가해야해요", style: const TextStyle(fontSize: 15)),
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

