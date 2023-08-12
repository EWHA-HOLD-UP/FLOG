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
    this.isUpload=false, //기본값은 false, 업로드하면 true로 값 변경
    required this.isAnswered,
  });
}

class Group {
  final String groupId; // 그룹 식별 아이디 ( == flogCode ???)
  final List<User> members; // 그룹에 해당하는 user 들 리스트화


  Group({
    required this.groupId,
    required this.members,
  });

  // *floging 기능 로직 : 자신의 상태를 업로드해야 다른 구성원 상태 확인 가능
  bool canViewPhotos(String userId) {
    final user = members.firstWhere((user) => user.uid == userId); //해당 userId에 해당하는 사용자를 찾기
    return user.isUpload; //해당 사용자의 isUpload 상태를 확인. 만약 해당 사용자가 이미 업로드한 상태라면 true를 반환
  }
}

// 여기에 Firestore 문서(DocumentSnapshot)와 데이터 간의 변환하는 백엔드 연동 코드 작성
