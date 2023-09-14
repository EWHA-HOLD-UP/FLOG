import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'memorybox_detail_screen.dart';

class MemoryBoxValuabledayShowAllScreen extends StatelessWidget {
  const MemoryBoxValuabledayShowAllScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int solvedPuzzle = 8; //다 푼 퍼즐 수 (임의 설정) - 나중에 파이어베이스에서 불러오기

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
            SizedBox(width: 95),
            Text('소중한 날',
              style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ],
        ),
        elevation: 0.0, //그림자 없음
        centerTitle: true,
      ),
      body: Center(
        child: SafeArea(
          child: Column(
              children: [
                SizedBox(height: 25), //간격
                Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8.0), // 각 컨테이너 사이의 간격 설정
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
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
                )


              ]
          ),
        ),
      ),
    );
  }
}

