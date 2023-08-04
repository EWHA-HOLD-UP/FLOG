import 'package:flog/screen/root_screen.dart';
import 'package:flutter/material.dart';

class MatchingCodeEnteringScreen extends StatelessWidget {
  const MatchingCodeEnteringScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 20),
                  Image.asset(
                  "assets/flog_logo.png",
                  width: 40,
                  height: 40
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'FLOG 코드를 입력해서 가족을 연결해주세요.',
                  style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ]
              ),
              const SizedBox(height: 20),
              const SizedBox(
                width: 340,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'code',
                    hintStyle: TextStyle(
                        color: Colors.black12,
                        fontWeight: FontWeight.w900,
                        fontSize: 25,
                        fontStyle: FontStyle.italic),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF609966)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26)
                    )
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RootScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: const Color(0xFF609966),
                  minimumSize: const Size(300, 50),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  '완료',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
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