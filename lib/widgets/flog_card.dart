// 업로드한 상태를 보여주는 카드 기능 구현
import 'package:flutter/material.dart';
import 'package:flog/screen/floging_detail_screen.dart';

class FlogCard extends StatelessWidget {
  final String status;

  const FlogCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlogingDetailScreen(status: status),
          ),
        );
      },
      child: Container(
        width: 150,
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xad747474),
          borderRadius: BorderRadius.circular(23),
        ),
        child: Center(
          child: Text(
            status,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
