import 'package:flutter/material.dart';

class MemoryBoxBookScreen extends StatelessWidget {
  const MemoryBoxBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
            child: Text('memory box book screen')
        ),
      ),
    );
  }
}