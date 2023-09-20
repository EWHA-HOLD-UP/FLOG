// 댓글 달기 기능 구현
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';


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

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
        .collection('User')
        .where('uid', isEqualTo: uid)
        .snapshots(),
    builder: (context, userSnapshot) {
      if (userSnapshot.hasError) {
        return Text('Error: ${userSnapshot.error}');
      }
      if (userSnapshot.connectionState ==
          ConnectionState.waiting) {
        return CircularProgressIndicator();
      }
      final userDocuments = userSnapshot.data!.docs;
      final userData = userDocuments.first.data() as Map<String, dynamic>;

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              child: Center(
                child: ClipOval(
                  child: Image.asset(
                    "assets/profile/profile_${userData['profile']}.png",
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                  ),
                ),
              ),
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
                            text: userData['nickname'],
                            style: GoogleFonts.nanumGothic(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          WidgetSpan(
                            child: SizedBox(width: 4),
                          ),
                          TextSpan(
                            text: DateFormat('yy.MM.dd HH:mm').format(date.toDate()),
                            style: GoogleFonts.nanumGothic(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600,),
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
    );
  }
}
