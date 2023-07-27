///찍은 사진 확인용
import 'dart:io';
import 'package:flutter/material.dart';

class ShootingPreviewScreen extends StatelessWidget {
  final String backImagePath;
  final String frontImagePath;

  const ShootingPreviewScreen({
    Key? key,
    required this.backImagePath,
    required this.frontImagePath,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('찍은 사진을 확인하세요'),
          backgroundColor: Colors.green,
          centerTitle: true
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(backImagePath != null)
            Image.file(
              File(backImagePath!),
                  width: 200,
                  height: 200,
              ),

          if(frontImagePath != null)
            Image.file(
                File(frontImagePath!),
                    width: 200,
                    height: 200,
              ),
        ],
      ),
    );
  }
}