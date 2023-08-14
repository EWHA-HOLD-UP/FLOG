// 업로드한 상태를 보여주는 카드 기능 구현
import 'package:flutter/material.dart';
import 'package:flog/screen/floging/floging_detail_screen.dart';

class FlogCard extends StatelessWidget {
  final String status;

  const FlogCard({required this.status, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlogingDetailScreen(flogingId: 'flogingID', status: status),
          ),
        );
      },
      child: Container(
        width: 150,
        height: 200,
        decoration: BoxDecoration(
          color: Color(0xad747474),
          borderRadius: BorderRadius.circular(23),
        ),
        child: Center(
          child: Text(
            status,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
