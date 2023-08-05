import 'package:flog/screen/family_matching_screen.dart';
import 'package:flutter/material.dart';


class BirthScreen extends StatefulWidget {
  final String nickname;
  const BirthScreen({required this.nickname, Key? key}) : super(key: key);
  @override
  State<BirthScreen> createState() => _BirthScreenState();
}

class _BirthScreenState extends State<BirthScreen> {
  TextEditingController birthController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void dispose(){
    birthController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    updateButtonStatus();
  }

  void updateButtonStatus(){
    setState(() {
      isButtonEnabled = birthController.text.length == 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child:
        Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 70),
                Row(
                    children: [
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
                              '${widget.nickname}님의 생일을 입력해주세요.',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )
                          ]
                      ),
                    ]
                ),
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        width: 340,
                        child: TextField(
                          maxLength: 4,
                          onChanged: (value) {
                            updateButtonStatus();
                          },
                          controller: birthController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: 'MMDD(ex. 10월 2일 : 1002)',
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
                              ),
                            helperText: birthController.text.length < 4
                              ? '4개의 숫자를 입력해주세요.'
                                : null,
                          ),
                        ),
                      ),

                      SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: isButtonEnabled
                          ? () {
                          String entered_nickname = widget.nickname;
                          String entered_birth = birthController.text;
                          if (entered_birth.isNotEmpty) {

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FamilyMatchingScreen(nickname: entered_nickname, birth: entered_birth)),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('생일을 입력해주세요.'))
                            );
                          }
                          }
                          :null,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Color(0xFF609966),
                          minimumSize: Size(300, 50),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          '다음',
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
              ],
            ),
          ),
        ),
    );
  }


}

