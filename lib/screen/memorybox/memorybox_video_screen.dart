import 'package:flutter/material.dart';

class MemoryBoxVideoScreen extends StatelessWidget {
  const MemoryBoxVideoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
            child: Text('memory box video screen')
        ),
      ),
    );
  }
}