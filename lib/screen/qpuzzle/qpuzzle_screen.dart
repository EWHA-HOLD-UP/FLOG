import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class QpuzzleScreen extends StatefulWidget {
  const QpuzzleScreen({Key? key}) : super(key: key);

  @override
  State<QpuzzleScreen> createState() => _QpuzzleScreenState();
}

class _QpuzzleScreenState extends State<QpuzzleScreen> {
  XFile? image;
  List<bool> unlockStates = List.generate(6, (index) => false); // 6개의 조각에 대한 잠금 상태를 나타내는 리스트

  void onPickImage() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery);
    final cropped_image = await ImageCropper()
        .cropImage(sourcePath: image!.path, aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 3));

    setState(() {
      this.image = XFile(cropped_image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
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
              Center(
                  child: renderBody()
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderBody() {
    if (image != null) {
      return Stack(
        children: [
          Container(
            width: 330,
            height: 495,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(image!.path)),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(23),
            ),
          ),
          Container(
            width: 330,
            height: 495,
            child: Column(
              children: [
                for (int row = 0; row < 3; row++)
                  Row(
                    children: [
                      for (int col = 0; col < 2; col++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              unlockStates[row * 2 + col] = true;
                            });
                          },
                          child: Container(
                            width: 165,
                            height: 165,
                            decoration: BoxDecoration(
                              color: unlockStates[row * 2 + col]
                                  ? Colors.transparent
                                  : Color(0xFF000000), //검정색으로 덮음
                              border: Border.all(
                                color: unlockStates[row * 2 + col]
                                    ? Colors.transparent // 잠금 해제된 셀
                                    : Colors.white, // 잠금 해제되지 않은 셀은 흰색 테두리
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    (row == 0 && col == 0) ? 23.0 : 0.0), // 1행1열
                                topRight: Radius.circular(
                                    (row == 0 && col == 1) ? 23.0 : 0.0), // 1행2열
                                bottomLeft: Radius.circular(
                                    (row == 2 && col == 0) ? 23.0 : 0.0), // 3행1열
                                bottomRight: Radius.circular(
                                    (row == 2 && col == 1) ? 23.0 : 0.0), // 3행2열
                              ),

                          ),
                        ),
                      )
                    ],
                  ),
              ],
            ),
          ),
        ],
      );
    }
    else {
      return Container(
        width: 330,
        height: 495,
        decoration: BoxDecoration(
          color: Color(0xad747474),
          borderRadius: BorderRadius.circular(23), // 모서리 둥글기 조절
        ),
        child: Center(
          child: InkWell(
            onTap: () {
              onPickImage();
            },
            child: Image.asset(
                "button/plus.png",
                width: 30,
                height: 30
            ),
          ),
        ),
      );
    }
  }
}