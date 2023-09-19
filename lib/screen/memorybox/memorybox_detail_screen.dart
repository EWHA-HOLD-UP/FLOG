import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/flog_card.dart';

class MemoryBoxDetailScreen extends StatefulWidget {
  final String selectedDate; // 선택된 날짜를 저장하는 변수 추가
  const MemoryBoxDetailScreen({Key? key, required this.selectedDate})
      : super(key: key);
  @override
  MemoryBoxDetailState createState() => MemoryBoxDetailState();
}


class MemoryBoxDetailState extends State<MemoryBoxDetailScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String currentUserFlogCode = ""; // 현재 로그인한 사용자의 flogCode

  @override
  void initState() {
    super.initState();
    getUserFlogCode();
  }

  // 현재 로그인한 사용자의 flogCode를 Firestore에서 가져오는 함수
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


  @override
  Widget build(BuildContext context) {

      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('User')
            .where('flogCode', isEqualTo: currentUserFlogCode)
            .snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.hasError) {
            return Text('Error: ${userSnapshot.error}');
          }
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator()
            );
          }
          final userDocuments = userSnapshot.data!.docs;
          return Scaffold(
            body:Center(
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
                          child: ListView.builder(
                            itemCount: userDocuments.length,
                            itemBuilder: (context, index) {
                              final userData = userDocuments[index].data() as Map<String, dynamic>;
                              final userProfile = userData['profile'];
                              final userNickname = userData['nickname'];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Hero(
                                          tag: "profile",
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey[200],
                                                ),
                                                child: Center(
                                                  child: ClipOval(
                                                    child: Image.asset(
                                                      "assets/profile/profile_${userProfile}.png",
                                                      width: 50,
                                                      height: 50,
                                                      alignment: Alignment.center,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          userNickname,
                                          style: GoogleFonts.nanumGothic(
                                            textStyle: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff609966),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('Floging')
                                        .where('uid', isEqualTo: userData['email'])
                                        .snapshots(),
                                    builder: (context, flogSnapshot) {
                                      if (flogSnapshot.hasError) {
                                        return Text('Error: ${flogSnapshot.error}');
                                      }
                                      if (flogSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      }
                                      final flogDocuments = flogSnapshot.data!.docs;

                                      flogDocuments.sort((a, b) {
                                        final aData = a.data() as Map<String, dynamic>;
                                        final bData = b.data() as Map<String, dynamic>;
                                        final aDate = aData['date'] as Timestamp;
                                        final bDate = bData['date'] as Timestamp;
                                        return bDate.compareTo(aDate); // 내림차순으로 정렬
                                      });
                                      return Container(
                                        height: 200,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: flogDocuments.map((flogDoc) {
                                            final flogData = flogDoc.data() as Map<String, dynamic>;
                                            final timestamp = flogData['date'] as Timestamp;
                                            final dateTime = timestamp.toDate();

                                            // DateTime에서 년, 월, 일 추출
                                            final year = dateTime.year % 100;
                                            final month = dateTime.month;
                                            final day = dateTime.day;
                                            // selectedDate를 "23.09.19" 형식으로 파싱하여 년, 월, 일 추출
                                            final selectedParts = widget.selectedDate.split('.');
                                            final selectedYear = int.parse(selectedParts[0]);
                                            final selectedMonth = int.parse(selectedParts[1]);
                                            final selectedDay = int.parse(selectedParts[2]);
                                            if (year == selectedYear && month == selectedMonth && day == selectedDay) {
                                              return Row(
                                                children: [
                                                FlogCard(
                                                  date: flogData['date'],
                                                  frontImageURL: flogData['downloadUrl_front'],
                                                  backImageURL: flogData['downloadUrl_back'],
                                                  flogCode: flogData['flogCode'],
                                                  flogingId: flogData['flogingId'],
                                                  uid: flogData['uid'],
                                                ),
                                                SizedBox(width: 10),
                                              ],
                                            );} else { return Container();}
                                          }).toList(),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 20),
                                ],
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
        );
  }
}