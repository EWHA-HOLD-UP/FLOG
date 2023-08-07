import 'dart:math' as math;
import 'package:flog/screen/root_screen.dart';
import 'package:flog/screen/floging/shooting_screen_back.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ShootingEditScreen extends StatefulWidget {
  final String backImagePath;
  final String frontImagePath;

  const ShootingEditScreen({
    Key? key,
    required this.backImagePath,
    required this.frontImagePath,
  }) : super(key: key);

  @override
  _ShootingEditState createState() => _ShootingEditState();
}

class _ShootingEditState extends State<ShootingEditScreen> {

  //플립 기능 위한 부분
  bool isFrontImageVisible = true;

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
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        // close 버튼 클릭 시 다시 ShootingScreen으로 이동 - 처음부터 다시 찍기
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShootingScreen(),
                          ),
                        );
                      },
                    ),
                    Center(
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isFrontImageVisible = !isFrontImageVisible;
                            });
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                            Visibility(
                              visible: !isFrontImageVisible,
                              child: Image.file(
                                File(widget.backImagePath),
                                width: 600,
                                height: 400,
                              ),
                            ),
                              Visibility(
                                visible: isFrontImageVisible,
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(math.pi),
                                  child: Image.file(
                                    File(widget.frontImagePath),
                                    width: 600,
                                    height: 400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ),
                  ],
              ),
            ),
          ),
        ),
    );
  }


}