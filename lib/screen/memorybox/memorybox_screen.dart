import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flog/screen/memorybox/memorybox_book_screen.dart';
import 'package:flog/screen/memorybox/memorybox_detail_screen.dart';
import 'package:flog/screen/memorybox/memorybox_everyday_showall_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/member_profile.dart';
import 'package:google_fonts/google_fonts.dart';

import 'memorybox_valuableday_showall_screen.dart';
import 'memorybox_video_screen.dart';

class MemoryBoxScreen extends StatefulWidget {
  const MemoryBoxScreen({Key? key}) : super(key: key);
  @override
  MemoryBoxState createState() => MemoryBoxState();
}

class MemoryBoxState extends State<MemoryBoxScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String currentUserFlogCode = ""; // 현재 로그인한 사용자의 flogCode
  int frog = 0;
  int coinNum = 1;

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('User').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final documents = snapshot.data!.docs;
        final profiles = documents
            .where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data['flogCode'] == currentUserFlogCode;
        })
            .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Person(
            profileNum: data['profile'],
            nickname: data['nickname'],
          );
        })
            .toList();

        return StreamBuilder<QuerySnapshot> (
            stream: FirebaseFirestore.instance.collection('Group').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              final documents = snapshot.data!.docs;
              final frogs = documents
                  .where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return data['flogCode'] == currentUserFlogCode;
              })
                  .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                frog = data['frog'];
                return frog;
              })
                  .toList();


              return Scaffold(
                /*---상단 Memory Box 바---*/
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  elevation: 0.0, // 그림자 없음
                  centerTitle: true,
                  title: Text(
                    'Memory Box',
                    style: GoogleFonts.balooBhaijaan2(
                      textStyle: TextStyle(
                        fontSize: 30,
                        color: Color(0xFF609966),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                /*---화면---*/
                backgroundColor: Colors.white, //화면 배경색
                body: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            for (final profile in profiles)
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Person(
                                  profileNum: profile.profileNum,
                                  nickname: profile.nickname,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    flogCoinNum(),
                    ourEveryday(),
                    ourValuableday(),
                  ],
                ),
              );
            }
        );
      },
    );
  }

  
  //모은 개구리 수 보여주기
  Widget flogCoinNum() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/flog_coin_green.png",
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 10),
          Text('모은 개구리 수 : $frog마리',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
          )),
        ],
      ),
    );
  }

  Widget ourEveryday() {
    final now = DateTime.now(); // 현재 날짜와 시간
    final startDate =
        DateTime(now.year, now.month, now.day - 13); // 오늘부터 13일 이전의 날짜 계산

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          const Text(
            '우리 가족의 모든 날',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          Container(
            height: 200,
            width: 350,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Flexible(
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: 14, // 14일간의 날짜 수
                    itemBuilder: (BuildContext context, int index) {
                      final currentDate = startDate.add(Duration(days: index));
                      final containerNumber = currentDate.day;
                      final formattedDate =
                          DateFormat('yy.MM.dd').format(currentDate);

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MemoryBoxDetailScreen(
                                selectedDate: formattedDate,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: currentDate.isAfter(now)
                                ? const Color(0xFFCED3CE)
                                : const Color(0xFFCED3CE).withOpacity(0.5),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: ClipRRect(
                                  child: Image.asset(
                                    "assets/emoticons/emoticon_$containerNumber.png",
                                    width: 35,
                                    height: 35,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  containerNumber.toString(),
                                  style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 133),
                    OutlinedButton(
                      onPressed: () {
                        // "전체 보기" 버튼 클릭 시 동작
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                MemoryBoxEverydayShowAllScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        '전체 보기',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          )),
                      ),
                    const SizedBox(width: 80),
                    InkWell(
                      onTap: () {
                        //자동 영상 생성
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MemoryBoxVideoScreen(),
                          ),
                        );
                      },
                      child: Image.asset(
                        "button/video.png",
                        width: 35,
                        height: 35,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget ourValuableday() {
    int solvedPuzzle = 8; //다 푼 퍼즐 수 (임의 설정) - 나중에 파이어베이스에서 불러오기
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          const Text(
            '우리 가족의 소중한 날',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          Container(
            height: 250,
            width: 350,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8.0), // 각 컨테이너 사이의 간격 설정
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.0 / 3.0, //가로:세로 2:3 비율
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0, // 행 사이의 간격
                    ),
                    itemCount: solvedPuzzle, //전체 사진 수
                    itemBuilder: (BuildContext context, int index) {
                      int reversedIndex = solvedPuzzle -
                          index; //역순으로 퍼즐 사진 인덱스 계산 : 가장 최근에 푼 것부터 보여주려고
                      String imagePath =
                          "assets/emoticons/emoticon_$reversedIndex.png"; //나중에 파이어베이스에서 받아오는 걸로 경로 수정

                      //각 그리드 아이템에 표시할 위젯을 반환
                      return Container(
                        margin: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white, width: 1.5),
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
                Row(
                  children: [
                    const SizedBox(width: 133),
                    OutlinedButton(
                      onPressed: () {
                        // "전체 보기" 버튼 클릭 시 동작
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                MemoryBoxValuabledayShowAllScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                          '전체 보기',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    const SizedBox(width: 80),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MemoryBoxBookScreen(),
                          ),
                        );
                      },
                      child: Image.asset(
                          //전송 버튼
                          "button/book.png",
                          width: 35,
                          height: 35),
                    ),
                  ],
                ),
                const SizedBox(height: 15)
              ],
            ),
          ),
          const SizedBox(height: 40)
        ],
      ),
    );
  }
}
