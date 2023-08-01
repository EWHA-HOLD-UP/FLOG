import 'package:flog/screen/birth_screen.dart';
import 'package:flog/screen/nickname_screen.dart';
import 'package:flutter/material.dart';

class matching_code_entering_screen extends StatelessWidget {
  const matching_code_entering_screen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20),
                  Image.asset(
                  "assets/flog_logo.png",
                  width: 40,
                  height: 40
                  ),
                  SizedBox(width: 5),
                  Text(
                    'FLOG 코드를 입력해서 가족을 연결해주세요.',
                  style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ]
              ),
              SizedBox(height: 20),
              Container(
                width: 340,
                child: TextField(
                  decoration: new InputDecoration(
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
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => nickname_screen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Color(0xFF609966),
                  minimumSize: Size(300, 50),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
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