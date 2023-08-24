import 'package:flutter/material.dart';

class MemoryBoxDetailScreen extends StatelessWidget {
  const MemoryBoxDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
            child: Text('memory box detail screen')
        ),
      ),
    );
  }
}