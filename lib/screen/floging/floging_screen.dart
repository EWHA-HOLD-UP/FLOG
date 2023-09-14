import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flog/screen/floging/floging_detail_screen.dart'; // 다른 파일의 Floging_Detail_Screen import
import 'package:flog/widgets/flog_card.dart';
import 'package:google_fonts/google_fonts.dart';


class FlogingScreen extends StatefulWidget {
  const FlogingScreen({Key? key}) : super(key: key);
  @override
  FlogingScreenState createState() => FlogingScreenState();
}

class FlogingScreenState extends State<FlogingScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String currentUserFlogCode = ""; // 현재 로그인한 사용자의 flogCode

  @override
  void initState() {
    super.initState();
    getUserFlogCode();
  }

  // 현재 로그인한 사용자의 flogCode를 Firestore에서 가져오는 함수
  Future<void> getUserFlogCode() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('User')
        .doc(currentUser.email)
        .get();

    if (userDoc.exists) {
      setState(() {
        currentUserFlogCode = userDoc.data()!['flogCode'];
      });
    }
    print(currentUserFlogCode);
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Floging').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final documents = snapshot.data!.docs;
        final flogCards = documents
            .where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data['flogCode'] == currentUserFlogCode;
        })
            .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return FlogCard(
            date: data['date'],
            frontImageURL: data['downloadUrl_front'],
            backImageURL: data['downloadUrl_back'],
            flogCode: data['flogCode'],
            flogingId: data['flogingId'],
            uid: data['uid'],
          );
        })
            .toList();
        // 날짜 기준으로 flogCards 리스트 정렬 (최신 순서대로)
        flogCards.sort((a, b) => b.date.compareTo(a.date));
        // 최신 요소 가져오기 (가장 첫 번째 요소)
        final latestFlogCard = flogCards.isNotEmpty ? flogCards[0] : null;


        return  Scaffold(
          extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              elevation: 0.0, // 그림자 없음
              centerTitle: true,
              title:
                  Text(
                    'FLOGing',
                    style: GoogleFonts.balooBhaijaan2(
                      textStyle: TextStyle(
                        fontSize: 30,
                        color: Color(0xFF609966),
                        fontWeight: FontWeight.bold,
                      ),
                  ),
              ),
            ),

          body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: 3 / 4,
              ),
              itemCount: flogCards.length,
              itemBuilder: (context, index) {
                return FlogCard(
                  date: flogCards[index].date,
                  frontImageURL: flogCards[index].frontImageURL,
                  backImageURL: flogCards[index].backImageURL,
                  flogCode: flogCards[index].flogCode,
                  flogingId: flogCards[index].flogingId,
                  uid: flogCards[index].uid,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
