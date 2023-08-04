
import 'package:flutter/material.dart';
import 'package:flog/screen/floging_detail_screen.dart'; // 다른 파일의 Floging_Detail_Screen import
import 'package:flog/widgets/flog_card.dart';

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
                  SizedBox(height:30),
                  Image.asset(
                    "assets/flog_logo.png",
                    width: 55,
                    height: 55,
                  ),
                  Text(
                    "FLOGing",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF609966), // #609966 색상 지정
                    ),
                  ),
              SizedBox(height:20), // 간격
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    String status = "플로깅 상태 ${index + 1}";
                    return FlogCard(status: status); // FlogCard 위젯 사용
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