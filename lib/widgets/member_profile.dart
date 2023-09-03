//프로필 표시하는 위젯

import 'package:flutter/material.dart';

//사용자 프로필에 관련된 데이터를 저장하기 위한 클래스
class Person {
  int profileNum; //프로필 사진 인덱스 받아오기
  String nickname; //닉네임
  Person(this.profileNum, this.nickname);
}

//Person 객체를 받아와서 해당 사용자의 프로필을 표시하는 위젯
class Profiles extends StatelessWidget {
  const Profiles(this._person, {super.key});
  final Person _person;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle, //원 모양 프로필 사진
            color: Colors.grey[200], //배경색
          ),
          child: Center(
            child: ClipOval(
              child: Image.asset(
                "assets/emoticons/emoticon_${_person.profileNum}.png", //현재는 모두 임의로 넣어둠 나중에 현서가 만든 프로필 사진들로 바꿔야함
                width: 60,
                height: 60,
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(_person.nickname),
      ],
    );
  }
}