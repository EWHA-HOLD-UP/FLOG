
import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'floging_detail_screen.dart'; // 다른 파일의 Floging_Detail_Screen import
=======
// 다른 파일의 Floging_Detail_Screen import
import 'package:flog/widgets/flog_card.dart';
>>>>>>> Stashed changes

class FlogingScreen extends StatelessWidget {
  const FlogingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height:30),
                  Image.asset(
                    "assets/flog_logo.png",
                    width: 55,
                    height: 55,
                  ),
                  const Text(
                    "FLOGing",
                    style: TextStyle(
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
                  itemCount: 3, // 박스의 개수
                  itemBuilder: (context, index) {
                    return InkWell(
                    onTap: () { // 클릭 시 다른 스크린으로 이동하는 로직 추가
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FlogingDetailScreen(),
                        ),
                      );
                    },
                      child: Container(
                      width: 150,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Color(0xad747474),
                        borderRadius: BorderRadius.circular(23), // 모서리 둥글기 조절
                      ),
                      child: Center(
                        child: Text(
                          "플로깅 상태 ${index + 1}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    );
                  },
                ),
              ),
              ),
                ],
              ),
            )

        ),
      ),
    );
  }
}