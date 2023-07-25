///찍은 사진 확인용
import 'dart:io';
import 'package:flutter/material.dart';

class PhotoPreview extends StatelessWidget {
  final String imagePath;

  const PhotoPreview({required this.imagePath, super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('찍은 사진을 확인하세요'),
          backgroundColor: Colors.green,
          centerTitle: true
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.file(
            File(imagePath),
          ),
        ),
      ),
    );
  }
}