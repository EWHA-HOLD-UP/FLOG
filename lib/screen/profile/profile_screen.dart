import 'package:flutter/material.dart';
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

  // 닉네임 수정하기
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

  Future<void> editImage(String field, String selectedImage) async {
    String newValue = selectedImage;
    int selectedIndex = int.tryParse(selectedImage) ?? -1; // 인덱스를 숫자로 다룸

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '개구리 선택하기',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // '저장' 버튼을 눌렀을 때의 동작 추가
                          if (selectedIndex != -1) {
                            setState(() {
                              newValue = selectedIndex.toString();
                            });
                            // selectedIndex에 선택된 이미지의 인덱스가 저장되어 있음
                            debugPrint('선택된 이미지 인덱스: $selectedIndex');
                            Navigator.pop(context); // 모달 닫기
                          }
                        },
                        child: Text(
                          '저장',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff609966), // 버튼 텍스트 색상
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3열로 배치
                      mainAxisSpacing: 5.0, // 수직 간격 설정
                      crossAxisSpacing: 5.0, // 수평 간격 설정
                      childAspectRatio: 1, // 가로:세로 비율을 1:1로 설정
                    ),
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 20), // GridView 내부 패딩 설정
                    itemCount: 12, // 이미지 버튼 개수
                    itemBuilder: (context, index) {
                      // 각 이미지를 asset에서 불러오기
                      final imagePath = 'assets/profile/profile_$index.png';

                      // 이미지 버튼 반환
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent, // 이미지 버튼의 배경색 설정
                          border: Border.all(
                            color: selectedIndex == index
                                ? Color(0xff609966) // 선택된 이미지의 테두리 색상
                                : Colors.transparent, // 선택되지 않은 이미지는 테두리 없음
                            width: 2.0, // 테두리 두께
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            debugPrint('debug: 클릭됨');
                            setState(() {
                              selectedIndex = index; // 선택된 이미지의 인덱스 업데이트
                            });
                          },
                          child: Image.asset(
                            imagePath, // 이미지 경로
                            fit: BoxFit.cover, // 이미지를 적절하게 조정
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    //파이어베이스 변경사항 업데이트하기
    if (newValue.trim().length > 0) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }


  // 화면 UI build
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
                                child: Image.asset('assets/profile/profile_${userData['profile']}.png',
                                  fit: BoxFit.cover,
                                ),
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Color(0xff609966), // 테두리 색상
                                    width: 2.0, // 테두리 두께
                                  ),
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
                                  onPressed: () => editImage('profile', userData['profile']),
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                        child: Text(userData['nickname'], style: const TextStyle(
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

