import 'package:flutter/material.dart';

class FlogingDetailScreen extends StatelessWidget {
  const FlogingDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    // 뒤로가기 버튼 클릭 시 이전 페이지(Floging_Screen)로 이동
                    Navigator.pop(context);
                  },
                ),
              ],
            ),

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
                color: Color(0xFF609966),
              ),
            ),
            SizedBox(height: 20), // 간격
          ],
        ),
      ),
    );
  }
}
