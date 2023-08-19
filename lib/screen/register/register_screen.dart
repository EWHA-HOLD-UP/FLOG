import 'package:flog/models/model_auth.dart';
import 'package:flog/models/model_register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterFieldModel(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black, // 뒤로가기 버튼 아이콘 색상
            ),// 이미지 경로 지정
            onPressed: () {
              Navigator.pop(context); // 뒤로가기 기능 추가
            },
          ),
          title: const Text('회원가입',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold, // 굵게 설정
            ),
          ),
          backgroundColor: Colors.transparent, // 투명 설정
          elevation: 0, // 그림자 제거
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 세로 중간 정렬
          children: [
            Image.asset(
              "assets/flog_name_3d.png",
              width: 180,
            ),
            SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft, // 좌측 정렬
              child: Padding(
                padding: EdgeInsets.only(left: 65.0), // 좌측으로 20.0만큼 패딩 추가
                child: Text(
                  '계정을 생성하세요.',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold, // 굵게 설정
                  ),
                ),
              ),
            ),
            EmailInput(),
            PasswordInput(),
            PasswordConfirmInput(),
            NicknameInput(),
            BirthInput(),
            SizedBox(height: 10),
            ReisterButton(),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, // 수직 가운데 정렬
                children: [
                  Text(
                    '이미 계정이 있으신가요?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10), // 원하는 간격을 설정
                  SignInButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerField =
        Provider.of<RegisterFieldModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        onChanged: (email) {
          registerField.setEmail(email);
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Email', // Hint Text
          hintText: 'example@example.com',
          labelStyle: TextStyle(
            color: Colors.grey, // labelText 색상 변경
            fontWeight: FontWeight.bold,
          ),
          hintStyle: TextStyle(
            color: Colors.grey, // hintText 색상 변경
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)), // 네모 상자의 모서리 둥글기 설정
            borderSide: BorderSide(color: Colors.grey), // 테두리 색 설정
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12), // 내용 안의 패딩 조정
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Color(0xFF609966), width: 2.0), // 선택됐을 때 테두리 색 변경
          ),
        ),
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerField =
        Provider.of<RegisterFieldModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        onChanged: (password) {
          registerField.setPassword(password);
        },
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password', // Hint Text
          hintText: '8자 이상 입력해주세요.',
          labelStyle: TextStyle(
            color: Colors.grey, // labelText 색상 변경
            fontWeight: FontWeight.bold,
          ),
          hintStyle: TextStyle(
            color: Colors.grey, // hintText 색상 변경
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)), // 네모 상자의 모서리 둥글기 설정
            borderSide: BorderSide(color: Colors.grey), // 테두리 색 설정
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12), // 내용 안의 패딩 조정
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Color(0xFF609966), width: 2.0), // 선택됐을 때 테두리 색 변경
          ),
        ),
      ),
    );
  }
}

class PasswordConfirmInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerField =
        Provider.of<RegisterFieldModel>(context); // listen == true
    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        onChanged: (password) {
          registerField.setPasswordConfirm(password);
        },
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password Confirm', // Hint Text
          hintText: '비밀번호를 다시 입력해주세요.',
          labelStyle: TextStyle(
            color: Colors.grey, // labelText 색상 변경
            fontWeight: FontWeight.bold,
          ),
          hintStyle: TextStyle(
            color: Colors.grey, // hintText 색상 변경
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)), // 네모 상자의 모서리 둥글기 설정
            borderSide: BorderSide(color: Colors.grey), // 테두리 색 설정
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12), // 내용 안의 패딩 조정
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Color(0xFF609966), width: 2.0), // 선택됐을 때 테두리 색 변경
          ),
          errorText: registerField.password != registerField.passwordConfirm
              ? "비밀번호가 일치하지 않습니다."
              : null,
        ),
        ),
    );
  }
}

class NicknameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerField =
        Provider.of<RegisterFieldModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        onChanged: (nickname) {
          registerField.setNickname(nickname);
        },
        decoration: InputDecoration(
          labelText: 'Nickname', // Hint Text
          hintText: '사용할 닉네임을 입력해주세요.',
          labelStyle: TextStyle(
            color: Colors.grey, // labelText 색상 변경
            fontWeight: FontWeight.bold,
          ),
          hintStyle: TextStyle(
            color: Colors.grey, // hintText 색상 변경
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)), // 네모 상자의 모서리 둥글기 설정
            borderSide: BorderSide(color: Colors.grey), // 테두리 색 설정
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12), // 내용 안의 패딩 조정
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Color(0xFF609966), width: 2.0), // 선택됐을 때 테두리 색 변경
          ),
        ),
      ),
    );
  }
}

class BirthInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerField =
        Provider.of<RegisterFieldModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        onChanged: (birth) {
          registerField.setBirth(birth);
        },
        decoration: InputDecoration(
          labelText: 'Birth', // Hint Text
          hintText: '생일을 입력해주세요. (YYMMDD)',
          labelStyle: TextStyle(
            color: Colors.grey, // labelText 색상 변경
            fontWeight: FontWeight.bold,
          ),
          hintStyle: TextStyle(
            color: Colors.grey, // hintText 색상 변경
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)), // 네모 상자의 모서리 둥글기 설정
            borderSide: BorderSide(color: Colors.grey), // 테두리 색 설정
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12), // 내용 안의 패딩 조정
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Color(0xFF609966), width: 2.0), // 선택됐을 때 테두리 색 변경
          ),
        ),
      ),
    );
  }
}

class ReisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authClient =
        Provider.of<FirebaseAuthProvider>(context, listen: false);
    final registerField =
        Provider.of<RegisterFieldModel>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.05,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color(0xff609966),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          onPressed: () async {
            await authClient
                .registerWithEmail(registerField.email, registerField.password,
                    registerField.nickname, registerField.birth)
                .then((registerStatus) {
              if (registerStatus == AuthStatus.registerSuccess) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text('회원가입이 완료되었습니다!')),
                  );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text('회원가입을 실패했습니다. 다시 시도해주세요.')),
                  );
              }
            });
          },
          child: Text('완료',
                style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold, // 굵게 설정
                ),
                ),
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'Sign In',
          style: TextStyle(color: theme.primaryColor),
        ));
  }
}
