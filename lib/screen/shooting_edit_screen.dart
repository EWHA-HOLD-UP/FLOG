import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'dart:io';

class ShootingEditScreen extends StatelessWidget {
  final String backImagePath;
  final String frontImagePath;

  const ShootingEditScreen({
    Key? key,
    required this.backImagePath,
    required this.frontImagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope( //뒤로가기 해서 사진 다시 찍는 것 막음
      onWillPop: () async => false,
      child:
        Scaffold(
          body: Center(
            child : SafeArea(
              child: Column(
                  children: [
                    SizedBox(height:10), //간격
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
                    SizedBox(height:20), //간격
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.file( //후면 카메라로 찍은 사진 불러오기
                          File(backImagePath),
                          width: 200,
                          height: 200,
                        ),
                        Transform( //전면 카메라로 찍은 사진 불러오기 (좌우 반전)
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: Image.file(
                            File(frontImagePath),
                            width: 200,
                            height: 200,
                          ),
                        ),
                      ],
                    ),
                  ]
              ),
            ),
          ),
        ),
    );
  }
}