import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../qpuzzle/image_helper.dart';

final imageHelper = ImageHelper();

class QpuzzleScreen extends StatefulWidget {
  const QpuzzleScreen({Key? key}) : super(key: key);

  @override
  State<QpuzzleScreen> createState() => _QpuzzleScreenState();
}

class _QpuzzleScreenState extends State<QpuzzleScreen> {
  File? _image;

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
                  child : FittedBox(
                    fit: BoxFit.contain,
                    child: Expanded(
                      child: SingleChildScrollView(
                        child:Container(
                          width: 300,
                          height: 400,
                          decoration: BoxDecoration(
                            color: Color(0xad747474),
                            borderRadius: BorderRadius.circular(23), // 모서리 둥글기 조절
                          ),
                            foregroundDecoration: BoxDecoration(
                            image: _image != null ? DecorationImage(
                              image: FileImage(_image!)
                            )
                                : null,
                            ),
                          child: Center(
                            child: InkWell(
                              onTap: () async {
                                final files = await imageHelper.pickImage();
                                if (files != null) {  // 파일 리스트가 null이 아니고 비어있지 않을 때
                                  final croppedFile = await imageHelper.crop(
                                    file: files,
                                    cropStyle: CropStyle.rectangle,
                                  );
                                  if (croppedFile != null) {  // 크롭된 파일이 null이 아닐 때
                                    setState(() {
                                      _image = File(croppedFile.path);
                                    });
                                  }
                                }
                              },
                              child: Image.asset(
                                  "button/plus.png",
                                  width: 30,
                                  height: 30
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}