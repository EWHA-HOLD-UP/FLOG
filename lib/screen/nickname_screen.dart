import 'package:flog/screen/birth_screen.dart';
import 'package:flutter/material.dart';

class NicknameScreen extends StatefulWidget {
  const NicknameScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NicknameScreenState();
}

class _NicknameScreenState extends State<NicknameScreen> {
  TextEditingController nicknameController = TextEditingController();
  bool _isNicknameEntered = false;

  @override
  void dispose() {
    nicknameController.dispose();
    super.dispose();
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
                          '닉네임을 입력해주세요. (10자 이내)',
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
                          maxLength: 10,
                          controller: nicknameController,
                          decoration: InputDecoration(
                              hintText: 'nickname',
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
                          String entered_nickname = nicknameController.text;
                          if (entered_nickname.isNotEmpty) {
                            _isNicknameEntered = true;
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BirthScreen(nickname: entered_nickname)),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('10자 이내의 닉네임을 입력해주세요.')),
                            );
                          }
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

