import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flog/screen/floging/floging_detail_screen.dart'; // 다른 파일의 Floging_Detail_Screen import
import 'package:flog/widgets/flog_card.dart';
import 'package:google_fonts/google_fonts.dart';


class FlogingScreen extends StatefulWidget {
  const FlogingScreen({Key? key}) : super(key: key);
  @override
  FlogingScreenState createState() => FlogingScreenState();
}

class FlogingScreenState extends State<FlogingScreen> {
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
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;

    final formattedDate = '$year.$month.$day';

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
        return CircularProgressIndicator();
        }

        final userDocuments = userSnapshot.data!.docs;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            centerTitle: true,
            title:
            Text(
              'FLOGing',
              style: GoogleFonts.balooBhaijaan2(
                textStyle: TextStyle(
                  fontSize: 30,
                  color: Color(0xFF609966),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          body: Padding(
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

                        // 데이터를 날짜를 기준으로 내림차순으로 정렬
                        flogDocuments.sort((a, b) {
                          final aData = a.data() as Map<String, dynamic>;
                          final bData = b.data() as Map<String, dynamic>;
                          final aDate = aData['date'] as Timestamp;
                          final bDate = bData['date'] as Timestamp;
                          return bDate.compareTo(aDate); // 내림차순으로 정렬
                        });

                        if (flogDocuments.isEmpty) {
                          // 만약 Flog Card가 없다면 빈 박스와 메시지를 표시
                          return Column(
                            children: [
                              Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xffd9d9d9),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'button/padlock.png', // 이미지 파일 경로
                                        width: 30, // 이미지 너비
                                        height: 30, // 이미지 높이
                                        // 다른 이미지 속성 설정
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '아직 상태를 업로드하지 않았어요.',
                                        style: GoogleFonts.nanumGothic(
                                          textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        }

                        return Container(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: flogDocuments.map((flogDoc) {
                              final flogData = flogDoc.data() as Map<String, dynamic>;
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
                              );
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
        );
      },
    );
  }
}
