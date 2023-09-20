// 댓글 달기 기능 구현
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';


class CommentCard extends StatelessWidget {
  final Timestamp date;
  final String commentId;
  final String text;
  final String uid;

  CommentCard({
    required this.date,
    required this.commentId,
    required this.text,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    child: Row(
      children: [
        CircleAvatar(
          radius: 18,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: text,
                        style: GoogleFonts.nanumGothic(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    DateFormat('dd.MM.yy HH:mm').format(date.toDate()),
                    style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w400,),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ),
    );
  }
}
