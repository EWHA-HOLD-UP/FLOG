import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flog/screen/floging/floging_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

                        return Container(
                          height: 200,
                          child: flogDocuments.any((flogDoc) {
                            final flogData = flogDoc.data() as Map<String, dynamic>;
                            final date = flogData['date'] as Timestamp;
                            final flogDate = DateTime.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch);
                            // 오늘 날짜에 해당하는 FlogCard가 있는지 확인
                            return flogDate.year == year && flogDate.month == month && flogDate.day == day;
                          })
                              ? ListView(
                            scrollDirection: Axis.horizontal,
                            children: flogDocuments
                                .where((flogDoc) {
                              final flogData = flogDoc.data() as Map<String, dynamic>;
                              final date = flogData['date'] as Timestamp;
                              final flogDate = DateTime.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch);
                              // 오늘 날짜에 해당하는 FlogCard만 표시
                              return flogDate.year == year && flogDate.month == month && flogDate.day == day;
                            })
                                .map((flogDoc) {
                              final flogData = flogDoc.data() as Map<String, dynamic>;
                              final flogingId = flogData['flogingId'];
                              final flogCode = flogData['flogCode'];
                              final date = flogData['date'];
                              final frontImageURL = flogData['downloadUrl_front'];
                              final backImageURL = flogData['downloadUrl_back'];
                              final uid = flogData['uid'];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FlogingDetailScreen(
                                        flogingId: flogingId,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    FlogCard(
                                      date: date,
                                      frontImageURL: frontImageURL,
                                      backImageURL: backImageURL,
                                      flogCode: flogCode,
                                      flogingId: flogingId,
                                      uid: uid,
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              );
                            })
                                .toList(),
                          )
                              : Column(
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
                                        'button/padlock.png',
                                        width: 30,
                                        height: 30,
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
