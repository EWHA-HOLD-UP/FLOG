import 'package:flutter/material.dart';

class WaitingForFamily extends StatefulWidget {
  final String familycode;
  const WaitingForFamily({required this.familycode, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WaitingState();
}

class _WaitingState extends State<WaitingForFamily>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0.0,
        leading: IconButton(
          icon: Image.asset('button/back_arrow.png', width: 20, height: 20),
          onPressed: () {
            Navigator.pop(context);
            },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 70),
              Image.asset(
                  "assets/flog_logo.png",
                  width: 40,
                  height: 40
              ),
              const SizedBox(height: 20),
              const Text(
                'FLOG 코드를 가족에게 공유하여',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const Text(
                '가족 그룹에 들어오라고 알려주세요!',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                widget.familycode,
                style: const TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}