// Q-puzzle 모델 클래스 정의 : 데이터베이스의 flogs 컬렉션에서 가져온 데이터를 표현하고 조작하기 위한 목적
import 'package:cloud_firestore/cloud_firestore.dart';

// Q-puzzle 모델
class Qpuzzle {
  final String puzzleId; // 식별을 위한 해당 큐퍼즐의 ID
  final DateTime date;
  final String flogCode;
  final int puzzleNo;
  final bool isComplete;
  final String pictureUrl;
  final int currentPiece;
  final List unlock;

  Qpuzzle(
      {required this.puzzleId,
      required this.date,
      required this.flogCode,
      required this.puzzleNo,
      required this.isComplete,
      required this.pictureUrl,
      required this.currentPiece,
      required this.unlock});

  static Qpuzzle fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Qpuzzle(
      puzzleId: snapshot["puzzleId"],
      puzzleNo: snapshot["puzzleNo"],
      date: snapshot["date"],
      flogCode: snapshot["flogCode"],
      isComplete: snapshot["isComplete"],
      pictureUrl: snapshot["pictureUrl"],
      currentPiece: snapshot["currentPiece"],
      unlock: snapshot["unlock"],
    );
  }

  Map<String, dynamic> toJson() => {
        "puzzleId": puzzleId,
        "puzzleNo": puzzleNo,
        "date": date,
        "flogCode": flogCode,
        "isComplete": isComplete,
        "pictureUrl": pictureUrl,
        "currentPiece": currentPiece,
        "unlock": unlock,
      };
}