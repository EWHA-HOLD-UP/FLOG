import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class MemoryBoxVideoScreen extends StatefulWidget {
  @override
  MemoryBoxVideoState createState() => MemoryBoxVideoState();
}

class MemoryBoxVideoState extends State<MemoryBoxVideoScreen> {
  late VideoPlayerController _controller; //VideoPlayerController를 선언

  @override
  void initState() {
    super.initState();
    // 동영상 파일의 경로 또는 네트워크 URL을 지정합니다.
    _controller = VideoPlayerController.asset("assets/your_video.mp4") //없는 파일 - 나중에 수정 필요!!!!
      ..initialize().then((_) {
        //동영상을 초기화한 후 재생
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentMonth = now.month;
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
          SizedBox(height: 70),
          Center(
            child: Container(
              margin: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white, width: 1.5),
                color: const Color(0xFFCED3CE),
              ),
              child: Center(
                child: _controller.value.isInitialized
                    ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller), //동영상을 표시
                )
                    : CircularProgressIndicator(), //동영상 초기화 중에 로딩 표시
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(
              child: Text(
                '$currentMonth월 우리 가족의 모습을',
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
                '영상으로 만나보세요!',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
              )
          ),

        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose(); //페이지를 나갈 때 VideoPlayerController를 해제
  }
}
