import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'memorybox_detail_screen.dart';

class MemoryBoxEverydayShowAllScreen extends StatelessWidget {
  const MemoryBoxEverydayShowAllScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final now = DateTime.now(); //현재 날짜와 시간
    final year = DateFormat('yyyy').format(now);
    final month = DateFormat('MM').format(now);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell( //close 아이콘 버튼
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
              "button/back_arrow.png",
              width: 20,
              height: 20
          ),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const SizedBox(width: 110),
            const Text('모든날',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        elevation: 0.0, //그림자 없음
        centerTitle: true,
      ),
      body: Center(
        child : SafeArea(
          child: Column(
              children: [
                const SizedBox(height:10), //간격
                SizedBox(height: 15),
                Text(
                  '$year.$month', // 선택된 날짜를 여기에 표시
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height:20), // 간격
                ourEveryday()

              ]
          ),
        ),
      ),
    );
  }


  Widget ourEveryday() {
    final now = DateTime.now(); //현재 날짜와 시간
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0); //이번 달의 마지막 날짜
    final daysInMonth = lastDayOfMonth.day; //이번 달의 일 수
    int today = now.day; //오늘 날짜

    final year = DateFormat('yy').format(now);
    final month = DateFormat('MM').format(now);

    return Container(
      height: 350,
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
                itemCount: daysInMonth, //전체 날짜 수
                itemBuilder: (BuildContext context, int index) {
                  // 각 그리드 아이템에 표시할 위젯을 반환
                  final containerNumber = index + 1;
                  final day = containerNumber.toString().padLeft(2, '0'); // 일을 2자리로 표현하고 앞에 0을 채웁니다.
                  final formattedDate = '$year.$month.$day'; // 년, 월, 일을 조합해서 날짜를 만듭니다.
                  if (containerNumber > today) {
                    //containerNumber가 오늘 이후면 회색에 숫자만 적힌 빈 컨테이너
                    return GestureDetector(
                      onTap: () {

                      },
                      child: Container(
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
                      ),
                    );
                  }  else {
                    //containerNumber가 오늘이거나 그 이전이면 플로깅 이미지로 채워진 컨테이너
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => MemoryBoxDetailScreen(
                                selectedDate: formattedDate, // formattedDate에 선택된 날짜가 들어가도록 수정
                              )
                          ),
                        );
                        },
                      child: Container(
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
                      ),
                    );
                  }
                  },
              ),
            ),

      ]),
    );
  }

}