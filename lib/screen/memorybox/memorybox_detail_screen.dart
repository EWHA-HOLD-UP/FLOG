import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MemoryBoxDetailScreen extends StatefulWidget {
  final String selectedDate; // 선택된 날짜를 저장하는 변수 추가
  const MemoryBoxDetailScreen({Key? key, required this.selectedDate})
      : super(key: key);
  @override
  MemoryBoxDetailState createState() => MemoryBoxDetailState();
}
class MemoryBoxDetailState extends State<MemoryBoxDetailScreen> {
  // Firestore 인스턴스 생성
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // 현재 사용자의 이메일 가져오기
  final currentUser = FirebaseAuth.instance.currentUser!;
  int numOfMem = 0;

  @override
  void initState() {
    super.initState();
    getnumofMem(); // initState 내에서 호출
  }

  Future<void> getnumofMem() async {
    String? userEmail = currentUser.email; // 이메일 가져오기
    // 'User' 컬렉션에서 사용자 문서를 가져오기
    QuerySnapshot userQuerySnapshot = await firestore
        .collection('User')
        .where('email', isEqualTo: userEmail)
        .get();
    String userFlogCode = userQuerySnapshot.docs[0]['flogCode'];
    // 'Group' 컬렉션에서 그룹 문서의 레퍼런스 가져오기
    DocumentReference currentDocumentRef =
    firestore.collection('Group').doc(userFlogCode);
    // 그룹 문서를 가져와서 데이터를 읽음
    DocumentSnapshot groupDocumentSnapshot = await currentDocumentRef.get();
    setState(() {
      numOfMem = groupDocumentSnapshot['memNumber']; // 가족 명 수 파이어베이스에서 받아오기
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child : SafeArea(
          child: Column(
              children: [
                const SizedBox(height:10), //간격
                Row(
                  children: [
                    const SizedBox(width: 20), //간격
                    InkWell( //close 아이콘 버튼
                      onTap: () {
                        Navigator.pop(context);
                        },
                      child: Image.asset(
                          "button/back_arrow.png",
                          width: 20,
                          height: 20
                      ),
                    ),
                    const SizedBox(width: 135), //간격
                    Image.asset(
                      "assets/flog_logo.png",
                      width: 55,
                      height: 55,
                    ),
                  ],
                ),
                Text(
                  widget.selectedDate, // 선택된 날짜를 여기에 표시
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF609966), // #609966 색상 지정
                  ),
                ),
                const SizedBox(height:20), // 간격
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 20.0,
                        childAspectRatio: 3 / 4,
                      ),
                      itemCount: numOfMem,
                      itemBuilder: (context, index) {
                        String imagePath = "assets/emoticons/emoticon_${index+1}.png"; //나중에 파이어베이스에서 받아오는 걸로 경로 수정
                        //각 그리드 아이템에 표시할 위젯을 반환
                        return Container(
                          margin: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color(0xFFCED3CE),
                          ),
                          child: Center(
                            child: ClipRRect(
                              child: Image.asset(
                                imagePath,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        );
                        },
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