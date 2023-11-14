import 'package:flog/notification/fcm_controller.dart';
import 'package:flog/screen/floging/shooting_screen_back.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flog/screen/floging/floging_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flog/widgets/flog_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flog/widgets/checkTodayFlog.dart';
import 'dart:ui';

class FlogingScreen extends StatefulWidget {
  const FlogingScreen({Key? key}) : super(key: key);
  @override
  FlogingScreenState createState() => FlogingScreenState();
}

class FlogingScreenState extends State<FlogingScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String currentUserFlogCode = ""; // 현재 로그인한 사용자의 flogCode
  String currentUserNickname = "";
  bool currentUserUploaded = false;

  @override
  void initState() {
    super.initState();
    checkTodayFlog();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;

    final formattedDate = '$year.$month.$day';

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("User")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                //로딩바 구현 부분
                child: SpinKitPumpingHeart(
                  color: Colors.green.withOpacity(0.2),
                  size: 50.0, //크기 설정
                  duration: Duration(seconds: 5),
                ),
              ),
              backgroundColor: Colors.transparent,
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            if (snapshot.data == null || !snapshot.data!.exists) {
              return const Text('데이터 없음 또는 문서가 없음'); // Firestore 문서가 없는 경우 또는 데이터가 null인 경우 처리
            }
            // 이제 snapshot.data을 안전하게 사용할 수 있음
            Map<String, dynamic> currentUserData = snapshot.data!.data() as Map<String, dynamic>;

            currentUserFlogCode = currentUserData['flogCode'];
            currentUserNickname = currentUserData['nickname'];
            final currentUserUploaded = currentUserData['isUpload'];

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
                  return Scaffold(
                    body: Center(
                      //로딩바 구현 부분
                      child: SpinKitPumpingHeart(
                        color: Colors.green.withOpacity(0.2),
                        size: 50.0, //크기 설정
                        duration: Duration(seconds: 5),
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                  );
                }

                final userDocuments = userSnapshot.data!.docs;
                // currentUser를 가장 먼저 배열
                userDocuments.sort((a, b) {
                  final aData = a.data() as Map<String, dynamic>;
                  final bData = b.data() as Map<String, dynamic>;
                  final aEmail = aData['email'] as String;
                  final bEmail = bData['email'] as String;

                  if (aEmail == currentUser.email) {
                    return -1; // a를 먼저 배치
                  } else if (bEmail == currentUser.email) {
                    return 1; // b를 먼저 배치
                  } else {
                    // 다른 사용자들의 정렬 순서는 상관없으므로 동등하게 처리
                    return 0;
                  }
                });

                return Scaffold(
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    elevation: 0.0,
                    centerTitle: true,
                    title: Text(
                      'FLOGing',
                      style: GoogleFonts.balooBhaijaan2(
                        textStyle: TextStyle(
                          fontSize: 30,
                          color: Color(0xFF62BC1B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: ListView.builder(
                      itemCount: userDocuments.length,
                      itemBuilder: (context, index) {
                        final userData =
                            userDocuments[index].data() as Map<String, dynamic>;
                        final userProfile = userData['profile'];
                        final userNickname = userData['nickname'];
                        final userToken = userData['token'];
                        final isCurrentUser = userData['email'] == currentUser.email;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            !isCurrentUser ? Center(
                              child: ListTile(
                                leading: Hero(
                                  tag: "profile",
                                  child: Container(
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
                                ),
                                title: Text(
                                  userNickname,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF62BC1B),
                                  ),
                                ),
                                trailing: !isCurrentUser
                                    ? GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15.0), // 모서리 둥글게
                                                ),
                                                title: Text(
                                                  '개굴이기!',
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    color: Color(0xFF62BC1B),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                actions: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(10.0),
                                                            border: Border.all(
                                                              color: Color(0xFF62BC1B),
                                                              width: 1.0,          // 테두리 굵기
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Image.asset(
                                                                "button/love_letter.png",
                                                                width: 20,
                                                                height: 20,
                                                                color: const Color(0xFF62BC1B),
                                                              ),
                                                              const SizedBox(width: 10),
                                                              Text(
                                                                currentUserNickname,
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: Color(0xFF62BC1B),
                                                                ),
                                                              ),
                                                              const SizedBox(width: 10),
                                                              Image.asset(
                                                                "button/right_arrow.png",
                                                                width: 20,
                                                                height: 20,
                                                                color: const Color(0xFF62BC1B),
                                                              ),
                                                              const SizedBox(width: 10),
                                                              Text(
                                                                userNickname,
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: Color(0xFF62BC1B),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(height: 20),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors.grey.withOpacity(0.1), // 그림자의 색상
                                                                    spreadRadius: 3, // 그림자가 퍼지는 정도
                                                                    blurRadius: 2, // 그림자의 흐림 정도
                                                                    offset: Offset(0, 1), // 그림자의 위치 (가로, 세로)
                                                                  ),
                                                                ],
                                                              ),
                                                              child: TextButton(
                                                                child: Column(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/emoticons/emoticon_5.png",
                                                                      width: 50,
                                                                      height: 50,
                                                                    ),
                                                                    SizedBox(height: 8),
                                                                    Text(
                                                                      '뭐해?',
                                                                      style: TextStyle(
                                                                        fontSize: 15,
                                                                        color: Colors.black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                onPressed: () {
                                                                  sendNotification(
                                                                      userToken,
                                                                      "$userNickname! 뭐해?🤨",
                                                                      "지금 뭐하는지 $currentUserNickname님이 궁금해해요! ");
                                                                  // 또 다른 미안함 표현 버튼을 눌렀을 때 수행할 동작 추가
                                                                  // 이곳에 또 다른 미안함 표현 관련 코드를 추가하세요.
                                                                  Navigator.of(context).pop(); // 팝업 창 닫기
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors.grey.withOpacity(0.1), // 그림자의 색상
                                                                    spreadRadius: 3, // 그림자가 퍼지는 정도
                                                                    blurRadius: 2, // 그림자의 흐림 정도
                                                                    offset: Offset(0, 1), // 그림자의 위치 (가로, 세로)
                                                                  ),
                                                                ],
                                                              ),
                                                              child: TextButton(
                                                                child: Column(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/emoticons/emoticon_3.png",
                                                                      width: 50,
                                                                      height: 50,
                                                                    ),
                                                                    SizedBox(height: 8),
                                                                    Text(
                                                                      '사랑해',
                                                                      style: TextStyle(
                                                                        fontSize: 15,
                                                                        color: Colors.black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                onPressed: () {
                                                                  sendNotification(
                                                                      userToken,
                                                                      "$userNickname! 사랑해🥰",
                                                                      " $currentUserNickname님이 사랑을 고백했어요!");
                                                                  // 다른 미안함 표현 버튼을 눌렀을 때 수행할 동작 추가
                                                                  // 이곳에 다른 미안함 표현 관련 코드를 추가하세요.
                                                                  Navigator.of(context).pop(); // 팝업 창 닫기
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors.grey.withOpacity(0.1), // 그림자의 색상
                                                                    spreadRadius: 3, // 그림자가 퍼지는 정도
                                                                    blurRadius: 2, // 그림자의 흐림 정도
                                                                    offset: Offset(0, 1), // 그림자의 위치 (가로, 세로)
                                                                  ),
                                                                ],
                                                              ),
                                                              child:  TextButton(
                                                                child: Column(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/emoticons/emoticon_10.png",
                                                                      width: 50,
                                                                      height: 50,
                                                                    ),
                                                                    SizedBox(height: 8),
                                                                    Text(
                                                                      '고마워',
                                                                      style: TextStyle(
                                                                        fontSize: 15,
                                                                        color: Colors.black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                onPressed: () {
                                                                  sendNotification(
                                                                      userToken,
                                                                      "$userNickname! 고마워🥹",
                                                                      "지금 $currentUserNickname님이 고마움을 전했어요!");
                                                                  // 또 다른 미안함 표현 버튼을 눌렀을 때 수행할 동작 추가
                                                                  // 이곳에 또 다른 미안함 표현 관련 코드를 추가하세요.
                                                                  Navigator.of(context).pop(); // 팝업 창 닫기
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors.grey.withOpacity(0.1), // 그림자의 색상
                                                                    spreadRadius: 3, // 그림자가 퍼지는 정도
                                                                    blurRadius: 2, // 그림자의 흐림 정도
                                                                    offset: Offset(0, 1), // 그림자의 위치 (가로, 세로)
                                                                  ),
                                                                ],
                                                              ),
                                                              child: TextButton(
                                                                child: Column(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/emoticons/emoticon_4.png",
                                                                      width: 50,
                                                                      height: 50,
                                                                    ),
                                                                    SizedBox(height: 8),
                                                                    Text(
                                                                      '미안해',
                                                                      style: TextStyle(
                                                                        fontSize: 15,
                                                                        color: Colors.black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                onPressed: () {
                                                                  sendNotification(
                                                                      userToken,
                                                                      "$userNickname! 미안해😢",
                                                                      " $currentUserNickname님이 미안하대요!");
                                                                  // 미안함 표현 버튼을 눌렀을 때 수행할 동작 추가
                                                                  // 이곳에 미안함 표현 관련 코드를 추가하세요.
                                                                  Navigator.of(context).pop(); // 팝업 창 닫기
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Image.asset(
                                          "button/gaegul.png",
                                          width: 35,
                                          height: 35,
                                        )
                                      )
                                    : SizedBox(), // 현재 사용자면 아무것도 표시하지 않음
                              )
                            ): RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '$userNickname',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF62BC1B), // Change color for the userNickname
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' 님, \n오늘도 가족과 함께하세요!',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black, // Set the default color
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
                                if (flogSnapshot.connectionState == ConnectionState.waiting) {
                                  return Scaffold(
                                    body: Center(
                                      //로딩바 구현 부분
                                      child: SpinKitPumpingHeart(
                                        color: Colors.green.withOpacity(0.2),
                                        size: 50.0, //크기 설정
                                        duration: Duration(seconds: 5),
                                      ),
                                    ),
                                    backgroundColor: Colors.transparent,
                                  );
                                }
                                final flogDocuments = flogSnapshot.data!.docs;

                                // 데이터를 날짜를 기준으로 내림차순으로 정렬
                                flogDocuments.sort((a, b) {
                                  final aData =
                                      a.data() as Map<String, dynamic>;
                                  final bData =
                                      b.data() as Map<String, dynamic>;
                                  final aDate = aData['date'] as Timestamp;
                                  final bDate = bData['date'] as Timestamp;
                                  return bDate.compareTo(aDate); // 내림차순으로 정렬
                                });

                                return Container(
                                  height: 200,
                                  child: (() {
                                    if (flogDocuments.where((flogDoc) {
                                      final flogData = flogDoc.data() as Map<String, dynamic>;
                                      final date = flogData['date'] as Timestamp;
                                      final flogDate = DateTime.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch);
                                      return flogDate.year == year && flogDate.month == month && flogDate.day == day;
                                    }).isEmpty) {
                                      return !isCurrentUser ? Column(
                                        children: [
                                          Container(
                                            height: 200,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Color(0xFFD9D9D9), width: 2),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      'button/padlock.png',
                                                      width: 30,
                                                      height: 30,
                                                      color: Color(0xFFD9D9D9)
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    '아직 상태를 업로드하지 않았어요.',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Color(0xFF5C5C5C)
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ) : Center(
                                        child: Container(
                                          height: 200,
                                          width: 130,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Color(0xFFD9D9D9), width: 2),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: InkWell(
                                              onTap: () async {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => const ShootingScreen(),
                                                  ),
                                                );
                                              },
                                              child: Image.asset(
                                                "button/plus.png",
                                                width: 30,
                                                height: 30,
                                                color: Color(0xFF62BC1B),
                                              ),
                                            ),
                                          ),
                                        )
                                      );

                                    } else {
                                      if (currentUserUploaded) {
                                        return ListView(
                                          scrollDirection: Axis.horizontal,
                                          children:
                                              flogDocuments.where((flogDoc) {
                                            final flogData = flogDoc.data()
                                                as Map<String, dynamic>;
                                            final date =
                                                flogData['date'] as Timestamp;
                                            final flogDate = DateTime
                                                .fromMicrosecondsSinceEpoch(date
                                                    .microsecondsSinceEpoch);
                                            return flogDate.year == year &&
                                                flogDate.month == month &&
                                                flogDate.day == day;
                                          }).map((flogDoc) {
                                            final flogData = flogDoc.data()
                                                as Map<String, dynamic>;
                                            final flogingId =
                                                flogData['flogingId'];
                                            final flogCode =
                                                flogData['flogCode'];
                                            final date = flogData['date'];
                                            final frontImageURL =
                                                flogData['downloadUrl_front'];
                                            final backImageURL =
                                                flogData['downloadUrl_back'];
                                            final uid = flogData['uid'];

                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FlogingDetailScreen(
                                                      flogingId: flogingId,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  FlogCard(
                                                    date: date,
                                                    frontImageURL:
                                                        frontImageURL,
                                                    backImageURL: backImageURL,
                                                    flogCode: flogCode,
                                                    flogingId: flogingId,
                                                    uid: uid,
                                                  ),
                                                  SizedBox(width: 10),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            Container(
                                              height: 200,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffd9d9d9),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                    color: Color(0xFF62BC1B),
                                                    width: 2.0,
                                                  )),
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      'button/hidden.png',
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      '플로깅 후 $userNickname의 상태를 확인하세요!',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }
                                  })(),
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
        });
  }
}
