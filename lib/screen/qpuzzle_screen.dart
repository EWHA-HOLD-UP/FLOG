import 'package:flutter/material.dart';

class Qpuzzle_screen extends StatelessWidget {
  const Qpuzzle_screen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Image.asset(
                  "assets/flog_logo.png",
                  width: 55,
                  height: 55,
                ),
                Text(
                  "Q-puzzle",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF609966), // #609966 색상 지정
                  ),
                ),
                SizedBox(height: 20), // 간격
              ],
            ),
          ),
        ),
      ),
    );
  }
}