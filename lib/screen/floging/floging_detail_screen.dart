import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flog/widgets/flog_card.dart';
import 'package:google_fonts/google_fonts.dart';


class FlogingDetailScreen extends StatefulWidget {
  final String flogingId;

  const FlogingDetailScreen(
      {Key? key, required this.flogingId,}) : super(key: key);

  @override
  _FlogingDetailScreenState createState() => _FlogingDetailScreenState();
}

class _FlogingDetailScreenState extends State<FlogingDetailScreen> {

  @override
  Widget build(BuildContext context) {
    final flogingId = widget.flogingId;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Floging')
          .where('flogingId', isEqualTo: flogingId)
          .snapshots(),
      builder: (context, flogSnapshot) {
        if (flogSnapshot.hasError) {
          return Text('Error: ${flogSnapshot.error}');
        }
        if (flogSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final flogDocuments = flogSnapshot.data!.docs;

        // flogDocuments에서 필요한 데이터 추출
        final flogData = flogDocuments.first.data() as Map<String, dynamic>;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            centerTitle: true,
            title: Column (
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${flogData['uid'].split('@')[0]} FLOGing\n',
                      style: GoogleFonts.balooBhaijaan2(
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF609966),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: '${flogData['date'].toDate().hour.toString().padLeft(2, '0')}:${flogData['date'].toDate().minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 15, // 원하는 크기로 조정하세요
                        color: Color(0xFF609966),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ]
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                // 뒤로가기 버튼 클릭 시 이전 페이지(Floging_Screen)로 이동
                Navigator.pop(context);
              },
            ),
          ),
            body: SafeArea(
              child: Center(
              child: Column(
              children: [
                SizedBox(height: 20),
                Stack(
                children: <Widget>[
                  Container(
                  width: 260, // FlogCard의 너비 설정
                  height: 400, // FlogCard의 높이 설정
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(flogData['downloadUrl_back']),
                      fit: BoxFit.cover,
                    ),
                    color: Color(0xffd9d9d9),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                // 후면 사진 표시 (동그란 모양)
                Positioned(
                  top:16, // 상단 위치
                  right: 16, // 오른쪽 위치
                  child: Container(
                    width: 78,
                    height: 120,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(flogData['downloadUrl_front']),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
              ]
            ),
            ),
            ),
        );
      },
    );
  }
}