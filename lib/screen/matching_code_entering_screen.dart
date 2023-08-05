import 'package:flog/screen/root_screen.dart';
import 'package:flutter/material.dart';

class MatchingCodeEnteringScreen extends StatefulWidget {
  const MatchingCodeEnteringScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EnteringState();
}

class _EnteringState extends State<MatchingCodeEnteringScreen>{
  TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
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
              SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
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
                  controller: codeController,
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
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  String entered_familycode = codeController.text; //텍스트 필드에 입력된 가족코드 받아서 저장 - 파이어베이스에 넣을듯
                  Navigator.push(
                    context,
                    MaterialPageRoute( //다음 스크린으로 가족코드 전달되는지 확인 위해 매개변수로 전달
                        builder: (context) => RootScreen(matched_familycode: entered_familycode)
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