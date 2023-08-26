import 'package:flutter/material.dart';
import '../../widgets/member_profile.dart';

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
            const SizedBox(width: 60),
            Image.asset(
              "assets/flog_logo.png",
              width: 30, height: 30,
            ),
            const SizedBox(width: 10),
            const Text('Memory Box',
              style: TextStyle(
                color: Color(0xFF609966),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        elevation: 0.0, //그림자 없음
        centerTitle: true,
      ),

      /*---화면---*/
      backgroundColor: Colors.white, //화면 배경색
      body:  ListView(
        children: <Widget> [
          memberProfiles(numOfMem), //가족 구성원들의 프로필 보여주기
          flogCoinNum(), //모은 개구리 수 보여주기
          _buildMiddle_2(),
          _buildBottom(), //하단
        ],
      ),
    );
  }

  //가족 구성원들의 프로필 보여주기
  Widget memberProfiles(int numOfMem) {
    final List<Person> people = [];

    /* 나중에는 아래 people.add 5줄 다 지우고,

    getProfileNums{여기에 파이어베이스에서 숫자 받아오는 함수 구현}
    getNicknames{여기에 파이어베이스에서 닉네임 받아오는 함수 구현}
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
      child : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/flog_coin_green.png",
            width: 30, height: 30,
          ),
          const SizedBox(width: 10),
          Text('모은 개구리 수 : $coinNum마리', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget _buildMiddle_2() {
    int today = 7; //오늘 날짜
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          const Text('우리 가족의 모든 날',
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
                      padding: const EdgeInsets.all(8.0), // 각 컨테이너 사이의 간격 설정
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7, //열 수
                        mainAxisSpacing: 10.0, // 행 사이의 간격
                      ),
                      itemCount: 14, //전체 사진 수
                      itemBuilder: (BuildContext context, int index) {
                        //각 그리드 아이템에 표시할 위젯을 반환
                        final containerNumber = index + 1;
                        if (containerNumber > today) {
                          //containerNumber가 오늘 이후면 회색에 숫자만 적힌 빈 컨테이너
                          return Container(
                            margin: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                color: const Color(0xFFCED3CE),
                                borderRadius: BorderRadius.circular(15)
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              containerNumber.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        } else {
                          //containerNumber가 오늘이거나 그 이전이면 플로깅 이미지로 채워진 컨테이너
                          return Container(
                            margin: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color(0xFFCED3CE)
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: ClipRRect(
                                    child: Image.asset(
                                      "assets/emoticons/emoticon_$containerNumber.png", //날짜별 플로깅 사진으로 바꿔야함
                                      width: 35,
                                      height: 35,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                                Center(
                                    child: Text(containerNumber.toString(),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 133),
                    OutlinedButton(
                      onPressed: (){

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
                            fontSize: 15
                        ),
                      ),
                    ),
                    const SizedBox(width: 80),
                    InkWell(
                      onTap: () {

                        },
                      child: Image.asset( //전송 버튼
                          "button/video.png",
                          width: 35,
                          height: 35
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15)
              ],
            ),
          ),
        ]
      ),
    );
  }

  Widget _buildBottom() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          const Text('우리 가족의 소중한 날',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          Container(
            height: 200,
            width: 350,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10.0)
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.photo,
                      size: 120,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.photo,
                      size: 120,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(width: 125),
                    OutlinedButton(
                      onPressed: (){

                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        '전체 보기',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 80),
                    IconButton(
                      onPressed: (){

                      },
                      icon: const Icon(
                        Icons.menu_book,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}