// flog 모델 클래스 정의 : 데이터베이스의 flogs 컬렉션에서 가져온 데이터를 표현하고 조작하기 위한 목적
import 'package:cloud_firestore/cloud_firestore.dart';

// 1️⃣ 업로드된 floging
class Floging {
  final String flogingId; // 식별을 위한 해당 플로깅의 ID
  final DateTime date;
  final String uid;
  final int groupNo;
  final String downloadUrl;
  final List<Comment> comments; // 해당 플로깅 아래 달린 댓글들

  Floging({
    required this.flogingId,
    required this.date,
    required this.uid,
    required this.groupNo,
    required this.downloadUrl,
    this.comments = const [], // 기본값은 빈 리스트
  });
}

// 2️⃣ 해당 floging 아래 달린 댓글
class Comment {
  final String uid;
  final String content;
  final DateTime date;

  Comment({
    required this.uid,
    required this.content,
    required this.date,
  });
}

// 여기에 Firestore 문서(DocumentSnapshot)와 데이터 간의 변환하는 백엔드 연동 코드 작성
