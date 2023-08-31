import 'package:flutter/material.dart';

class MemoryBoxDetailScreen extends StatelessWidget {
  final String selectedDate; // 선택된 날짜를 저장하는 변수 추가
  const MemoryBoxDetailScreen({Key? key, required this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int numOfMem = 5; // 나중에 가족 명 수 파이어베이스에서 받아오기
    return Scaffold(
      body: Center(
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
                  selectedDate, // 선택된 날짜를 여기에 표시
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
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 20.0,
                        childAspectRatio: 3 / 4,
                      ),
                      itemCount: numOfMem,
                      itemBuilder: (context, index) {
                        String imagePath = "assets/emoticons/emoticon_${index+1}.png"; //나중에 파이어베이스에서 받아오는 걸로 경로 수정
                        //각 그리드 아이템에 표시할 위젯을 반환
                        return Container(
                          margin: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
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
                ),
              ]
          ),
        ),
      ),
    );
  }
}