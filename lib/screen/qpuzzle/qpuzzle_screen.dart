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

  void onPickImage() async {
    final image = await ImagePicker().
    pickImage(source: ImageSource.gallery);
    setState(() {
      this.image = image;
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
      return InteractiveViewer(
        child: Container(
            width: 300,
            height: 400,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: FileImage(
                      File(image!.path)
                  ),
                  fit: BoxFit.cover
              ),
              borderRadius: BorderRadius.circular(23), // 모서리 둥글기 조절
            ),
          ),
      );
    } else {
      return Container(
        width: 300,
        height: 400,
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