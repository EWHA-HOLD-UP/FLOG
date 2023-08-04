import 'package:flutter/material.dart';

class QpuzzleScreen extends StatelessWidget {
  const QpuzzleScreen({Key? key}) : super(key: key);

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
                const SizedBox(height: 30),
                Image.asset(
                  "assets/flog_logo.png",
                  width: 55,
                  height: 55,
                ),
                const Text(
                  "Q-puzzle",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF609966), // #609966 색상 지정
                  ),
                ),
                const SizedBox(height: 20), // 간격
              ],
            ),
          ),
        ),
      ),
    );
  }
}