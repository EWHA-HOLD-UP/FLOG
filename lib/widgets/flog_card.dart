// 업로드한 상태를 보여주는 카드 기능 구현
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flog/screen/floging/floging_detail_screen.dart';


class FlogCard extends StatelessWidget {
  final Timestamp date;
  final String frontImageURL;
  final String backImageURL;
  final String flogCode;
  final String flogingId;
  final String uid;

  FlogCard({
    required this.date,
    required this.frontImageURL,
    required this.backImageURL,
    required this.flogCode,
    required this.flogingId,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FlogingDetailScreen(
                flogingId: flogingId,
                flogCode: flogCode,
                date: date,
                frontImageURL: frontImageURL,
                backImageURL: backImageURL,
                uid: uid,),
            ),
          );
        },

      child: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(backImageURL),
                    fit: BoxFit.cover,
                ),
            color: Color(0xffd9d9d9),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Color(0xff609966),
              width: 3.0,
            ),
          ),
        ),
        // 후면 사진 표시 (동그란 모양)
        Positioned(
          top: 0, // 상단 위치
          right: 0, // 오른쪽 위치
          child: Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(frontImageURL),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: Color(0xff609966),
                width: 3.0,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0, // 상단 위치
          left: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${uid.split('@')[0]}', style: TextStyle(color: Colors.white),),
                Text('${date.toDate().toString()}', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        )
      ],
    ),
    );
  }
}
