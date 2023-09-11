import 'package:flog/screen/memorybox/memorybox_book_screen.dart';
import 'package:flog/screen/memorybox/memorybox_detail_screen.dart';
import 'package:flog/screen/memorybox/memorybox_everyday_showall_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/member_profile.dart';
import 'package:google_fonts/google_fonts.dart';

class MemoryBoxScreen extends StatefulWidget {
  const MemoryBoxScreen({Key? key}) : super(key: key);
  @override
  MemoryBoxState createState() => MemoryBoxState();
}

class MemoryBoxState extends State<MemoryBoxScreen> {
  int numOfMem = 5; // 나중에 가족 명 수 파이어베이스에서 받아오기

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*---상단 Memory Box 바---*/
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const SizedBox(width: 40),
            Image.asset(
              "assets/flog_logo.png",
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 10),
            Text('Memory Box',
                style: GoogleFonts.balooBhaijaan2(
                    textStyle: TextStyle(
                  fontSize: 30,
                  color: Color(0xFF609966),
                  fontWeight: FontWeight.bold,
                ))),
          ],
        ),
        elevation: 0.0, //그림자 없음
        centerTitle: true,
      ),

      /*---화면---*/
      backgroundColor: Colors.white, //화면 배경색
      body: ListView(
        children: <Widget>[
          memberProfiles(numOfMem), //가족 구성원들의 프로필 보여주기
          flogCoinNum(), //모은 개구리 수 보여주기
          ourEveryday(),
          ourValuableday(), //하단
        ],
      ),
    );
  }

  //가족 구성원들의 프로필 보여주기
  Widget memberProfiles(int numOfMem) {
    final List<Person> people = [];

    /* 나중에는 아래 people.add 5줄 다 지우고,

    getProfileNums{여기에 파이어베이스에서 순서대로 숫자:프사 인덱스 받아오는 함수 구현}
    getNicknames{여기에 파이어베이스에서 순서대로 닉네임 받아오는 함수 구현}
    for(int i = 1; i <= numOfMem; i++) {
      int 숫자 = getProfileNums();
      String 닉네임 = getNicknames();
      people.add(Person(숫자, 닉네임));
    }

    이렇게 하면 되지 않을까??
     */

    people.add(Person(1, '예원'));
    people.add(Person(2, '민교'));
    people.add(Person(3, '현서'));
    people.add(Person(4, '스크롤'));
    people.add(Person(5, '확인용'));

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // 가로 스크롤 설정
        child: Row(
          children: [
            for (final person in people)
              Row(
                children: [
                  const SizedBox(width: 20),
                  Profiles(person),
                ],
              )
          ],
        ),
      ),
    );
  }

  //모은 개구리 수 보여주기
  Widget flogCoinNum() {
    int coinNum = 29; //나중에 파이어베이스에서 받아오기
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
          Text('모은 개구리 수 : $coinNum마리',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                                  style: const TextStyle(color: Colors.white),
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
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 80),
                    InkWell(
                      onTap: () {
                        // 자동 영상 생성 구현 필요
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        //'전체보기' 클릭 시 나타나는 화면 제작 후 구현 필요
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        '전체 보기',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
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
          const SizedBox(height: 15)
        ],
      ),
    );
  }
}
