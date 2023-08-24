//꾸민 사진 잘 넘어오는지 테스트용

import 'dart:typed_data';

import 'package:flutter/material.dart';

class TScreen extends StatefulWidget {
  final Uint8List backImagePath;
  final Uint8List frontImagePath;

  const TScreen({
    Key? key,
    required this.backImagePath,
    required this.frontImagePath,
  }) : super(key: key);

  @override
  _TState createState() => _TState();
}

class _TState extends State<TScreen> {
  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Image.memory(
          widget.backImagePath,
          width: 250,
          height: 350,
        ),
        Image.memory(
          widget.frontImagePath,
          width: 250,
          height: 350,
        ),
      ],
    );
  }
}