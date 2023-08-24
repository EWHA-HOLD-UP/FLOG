import 'package:flutter/material.dart';
import 'package:flog/screen/register/personal_birth_screen.dart';

class NicknameScreen extends StatefulWidget {
  const NicknameScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NicknameScreenState();
}

class _NicknameScreenState extends State<NicknameScreen> {
  TextEditingController nicknameController = TextEditingController();
  bool isButtonEnabled = false; //'다음' 버튼 비활성화

  @override
  void dispose() {
    nicknameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    updateButtonStatus();
  }

  void updateButtonStatus() {
    //글자가 입력되면 '다음' 버튼 활성화
    setState(() {
      isButtonEnabled = nicknameController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //뒤로가기 방지
      onWillPop: () async => false,
      child: Scaffold(
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
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const SizedBox(width: 20),
                  Image.asset("assets/flog_logo.png", width: 40, height: 40),
                  const SizedBox(width: 5),
                  const Text(
                    '닉네임을 입력해주세요.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ]),
              ]),
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 340,
                      child: TextField(
                        maxLength: 10,
                        onChanged: (value) {
                          updateButtonStatus();
                        },
                        controller: nicknameController,
                        decoration: const InputDecoration(
                            //힌트
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
                                borderSide: BorderSide(color: Colors.black26)),
                            helperText: '10자 이내로 입력해주세요.'),
                      ),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                              String enteredNickname = nicknameController.text;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BirthScreen(
                                        nickname: enteredNickname)),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: const Color(0xFF609966),
                        minimumSize: const Size(300, 50),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text(
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
