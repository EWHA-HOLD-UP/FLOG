import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'memorybox_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MemoryBoxValuabledayShowAllScreen extends StatefulWidget {
  const MemoryBoxValuabledayShowAllScreen({Key? key}) : super(key: key);

  @override
  _MemoryBoxValuabledayShowAllScreenState createState() =>
      _MemoryBoxValuabledayShowAllScreenState();
}

class _MemoryBoxValuabledayShowAllScreenState
    extends State<MemoryBoxValuabledayShowAllScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String currentUserFlogCode = "";

  @override
  void initState() {
    super.initState();
    getUserFlogCode();
  }

  //현재 로그인한 사용자의 flogCode를 Firestore에서 가져오는 함수
  Future<void> getUserFlogCode() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('User')
        .doc(currentUser.email)
        .get();

    if (userDoc.exists) {
      setState(() {
        currentUserFlogCode = userDoc.data()!['flogCode'];
      });
    }
    print(currentUserFlogCode);
  }

  Future<List<String>> getQuestions(int puzzleNumber) async {
    final questions = <String>[];

    final querySnapshot = await FirebaseFirestore.instance
        .collection('Question')
        .where('puzzleNo', isEqualTo: puzzleNumber)
        .orderBy('questionNo')
        .get();

    for (final doc in querySnapshot.docs) {
      final questionContent = doc['questionContent'] as String;
      questions.add(questionContent);
    }

    return questions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SizedBox(width: 95),
            Text(
              '소중한 날',
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 25),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Qpuzzle')
                      .where('flogCode', isEqualTo: currentUserFlogCode)
                      .where('isComplete', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    final docs = snapshot.data?.docs ?? [];

                    if (docs.isEmpty) {
                      return Center(
                        child: Text(
                          '완성된 소중한 날이 아직 없어요.\n\n어서 큐퍼즐을 완성해보세요!',
                          style: GoogleFonts.nanumGothic(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black38,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return ListView(
                      children: docs.map((doc) {
                        final imagePath = doc['pictureUrl'];
                        final puzzleNumber = doc['puzzleNo'];

                        return FutureBuilder<List<String>>(
                          future: getQuestions(puzzleNumber),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // 데이터를 가져오는 중이면 로딩 표시 또는 다른 UI 표시 가능
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              // 에러가 발생하면 에러 메시지 표시 또는 다른 오류 처리
                              print('Error: ${snapshot.error}');
                              return Text('Error: ${snapshot.error}');

                            }
                            final questions = snapshot.data;

                            if (questions != null) {
                              // questions가 null이 아닌 경우에만 .map 호출
                              return Row(
                                children: [
                                  Stack(
                                    children:[
                                      Container(
                                        width: 200,
                                        height: 300,
                                        margin: const EdgeInsets.all(3.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(color: Colors.white, width: 1.5),
                                          color: const Color(0xFFCED3CE),
                                          image: DecorationImage(
                                            image: NetworkImage(imagePath),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        left: 10,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Color(0x99ffffff),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '#$puzzleNumber',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]
                                  ),
                                  SizedBox(width: 10), // 사진과 질문 사이 간격
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: questions.asMap().entries.map((entry) {
                                        final questionNo = entry.key + 1; // questionNo는 0부터 시작하지 않고 1부터 시작한다고 가정
                                        final question = entry.value;
                                        return Column(
                                          children: [
                                            if (entry.key > 0) Divider(height: 1, thickness: 1, color: Color(0xff609966)), // 상단 구분선 (첫 번째 질문 이후부터 추가)
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0), // 상단과 하단 간격 조절
                                              child: Text(
                                                '#$questionNo. $question',
                                                style: GoogleFonts.nanumGothic(
                                                  textStyle: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),

                                ],
                              );
                            } else {
                              // questions가 null인 경우에 대한 대체 처리
                              return CircularProgressIndicator(); // 예를 들어 로딩 중 표시
                            }
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


