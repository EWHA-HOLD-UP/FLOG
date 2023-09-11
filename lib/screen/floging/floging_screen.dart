import 'package:flutter/material.dart';
import 'package:flog/screen/floging/floging_detail_screen.dart'; // 다른 파일의 Floging_Detail_Screen import
import 'package:flog/widgets/flog_card.dart';
import 'package:google_fonts/google_fonts.dart';

class FlogingScreen extends StatelessWidget {
  const FlogingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Image.asset(
              "assets/flog_logo.png",
              width: 55,
              height: 55,
            ),
            Text("FLOGing",
                style: GoogleFonts.balooBhaijaan2(
                    textStyle: TextStyle(
                  fontSize: 40,
                  color: Color(0xFF609966),
                  fontWeight: FontWeight.bold,
                ))),
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
      )),
    );
  }
}
