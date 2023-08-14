// user 모델 클래스 정의 : 데이터베이스의 users 컬렉션에서 가져온 데이터를 표현하고 조작하기 위한 목적
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String? uid;
  final String nickname;
  final String birth;
  final String profile;
  final String flogCode; // 소속된 가족 코드
  final bool isUpload; // 플로깅 업로드 여부 확인
  final bool isAnswered; // 큐퍼즐 답변 여부 확인

  User({
    required this.uid,
    required this.nickname,
    required this.birth,
    required this.profile,
    required this.flogCode,
    required this.isUpload,
    required this.isAnswered,
  });

  User.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        nickname = json['nickname'],
        birth = json['birth'],
        profile = json['profile'],
        flogCode = json['flogCode'],
        isUpload = json['isUpload'],
        isAnswered = json['isAnswered'];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'nickname': nickname,
        'birth': birth,
        'profile': profile,
        'flogCode': flogCode,
        'isUpload': isUpload,
        'isAnswered': isAnswered,
      };
}

// 현재 로그인된 사용자의 UID를 가져오는 함수
Future<String?> getCurrentUserUID() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser as User?;

  if (user != null) {
    return user.uid;
  } else {
    return null;
  }
}

Future<void> save(CollectionReference userRef, User user) async {
  String? uid = await getCurrentUserUID();
  if (uid != null) {
    userRef.doc(uid).set(user.toJson());
  }
}
