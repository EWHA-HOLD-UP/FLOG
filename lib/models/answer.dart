// Answer 모델 클래스 정의
import 'package:cloud_firestore/cloud_firestore.dart';

// Answer 모델
class Answer {
  final String answerId; // 식별을 위한 해당 답변의 ID
  final DateTime date;
  final String flogCode;
  final int puzzleNo;
  final int questionNo;
  final bool isEveryoneComplete;
  final Map answers;

  Answer(
      {required this.answerId,
        required this.date,
        required this.flogCode,
        required this.puzzleNo,
        required this.questionNo,
        required this.isEveryoneComplete,
        required this.answers
      });

  static Answer fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Answer(
      answerId: snapshot["answerId"],
      date: snapshot["date"],
      flogCode: snapshot["flogCode"],
      puzzleNo: snapshot["puzzleNo"],
      questionNo: snapshot["questionNo"],
      isEveryoneComplete: snapshot["isEveryoneComplete"],
      answers: snapshot["answers"]
    );
  }

  Map<String, dynamic> toJson() => {
    "answerId": answerId,
    "date": date,
    "flogCode": flogCode,
    "puzzleNo": puzzleNo,
    "questionNo": questionNo,
    "isEveryoneComplete": isEveryoneComplete,
    "answers": answers
  };
}
