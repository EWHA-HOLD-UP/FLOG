import 'package:flutter/material.dart';

class MemoryBoxBookScreen extends StatelessWidget {
  const MemoryBoxBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*---상단 Memory Box 바---*/
        appBar: AppBar(
          leading: InkWell( //close 아이콘 버튼
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
                "button/back_arrow.png",
            ),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              const SizedBox(width: 50),
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
        body: Column(
          children: [
            SizedBox(height: 50),
            Center(
                child: Text(
                  '가족들의 소중한 사진을',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )
            ),
            Center(
                child: Text(
                  '오프라인으로 만나보세요!',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )
            ),
            SizedBox(height: 20),
            Image.asset(
              "assets/flog_logo.png",
              width: 300, height: 300,
            ),
            ElevatedButton(
              //상태 전송 버튼을 누르면
              onPressed: (){},
              //상태 전송 버튼 디자인
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 둥근 모서리 설정
                  ),
                  fixedSize: const Size(180, 55),
                  backgroundColor: const Color(0xFF609966)
              ),
              child: const Text(
                '추억북 신청하기',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
    );
  }
}