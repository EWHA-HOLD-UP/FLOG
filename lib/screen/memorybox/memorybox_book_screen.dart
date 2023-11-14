import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MemoryBoxBookScreen extends StatelessWidget {
  const MemoryBoxBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*---상단 Memory Box 바---*/
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black, // 뒤로가기 버튼 아이콘 색상
          ), // 이미지 경로 지정
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 기능 추가
          },
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const SizedBox(width: 35),
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
        body: Column(
          children: [
            SizedBox(height: 50),
            Center(
                child: Text(
                  '가족들의 소중한 사진을',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                )
            ),
            Center(
                child: Text(
                  '오프라인으로 만나보세요!',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                )
            ),
            SizedBox(height: 20),
            Image.asset(
              "assets/flog_logo.png",
              width: 300, height: 300,
            ),
            ElevatedButton(
              //추억북 신청하기 버튼을 누르면
              onPressed: (){},
              //추억북 신청하기 버튼 디자인
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 둥근 모서리 설정
                  ),
                  fixedSize: const Size(270, 60),
                  backgroundColor: const Color(0x86609966)
              ),
              child: Text(
                '추억북 신청하기',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ],
        ),
    );
  }
}