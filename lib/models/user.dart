// user 모델 클래스 정의 : 데이터베이스의 users 컬렉션에서 가져온 데이터를 표현하고 조작하기 위한 목적
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String nickname;
  final DateTime birth;
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
}

// 여기에 Firestore 문서(DocumentSnapshot)와 데이터 간의 변환하는 백엔드 연동 코드 작성
