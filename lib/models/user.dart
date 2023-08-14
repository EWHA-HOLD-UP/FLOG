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
    this.isUpload = false, //기본값은 false, 업로드하면 true로 값 변경
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

class Group {
  final String groupId; // 그룹 식별 아이디 ( == flogCode ???)
  final List<User> members; // 그룹에 해당하는 user 들 리스트화

  Group({
    required this.groupId,
    required this.members,
  });

  // *floging 기능 로직 : 자신의 상태를 업로드해야 다른 구성원 상태 확인 가능
  bool canViewPhotos(String userId) {
    final user = members
        .firstWhere((user) => user.uid == userId); //해당 userId에 해당하는 사용자를 찾기
    return user
        .isUpload; //해당 사용자의 isUpload 상태를 확인. 만약 해당 사용자가 이미 업로드한 상태라면 true를 반환
  }
}

// 여기에 Firestore 문서(DocumentSnapshot)와 데이터 간의 변환하는 백엔드 연동 코드 작성
