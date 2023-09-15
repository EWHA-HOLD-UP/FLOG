import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';


class FlogingDetailScreen extends StatefulWidget {
  final Timestamp date;
  final String frontImageURL;
  final String backImageURL;
  final String flogCode;
  final String flogingId;
  final String uid;

  const FlogingDetailScreen(
      {Key? key,
        required this.flogingId,
        required this.date,
        required this.flogCode,
        required this.frontImageURL,
        required this.backImageURL,
        required this.uid,})
      : super(key: key);

  @override
  _FlogingDetailScreenState createState() => _FlogingDetailScreenState();
}

class _FlogingDetailScreenState extends State<FlogingDetailScreen> {


  @override
  Widget build(BuildContext context) {
    final date = widget.date;
    final frontImageURL = widget.frontImageURL;
    final backImageURL = widget.backImageURL;
    final flogCode = widget.flogCode;
    final flogingId = widget.flogingId;
    final uid = widget.uid;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent, // 앱바 배경 색상
          elevation: 0, // 그림자 제거
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black, // 뒤로가기 버튼 아이콘 색상
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/flog_logo.png",
                    width: 55,
                    height: 55,
                  ),
                  Text(
                    '${uid.split('@')[0]} FLOGing',
                    style: GoogleFonts.balooBhaijaan2(
                      textStyle: TextStyle(
                        fontSize: 30,
                        color: Color(0xFF609966),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text('${date.toDate().toString()}', style: TextStyle(color: Colors.black)),
                  const SizedBox(height: 20), // 간격
                  Expanded(
                    child: Stack(
                        children: <Widget>[
                          Container(
                            width: 300,
                            height: 400,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: NetworkImage(backImageURL),
                                fit: BoxFit.cover,
                              ),
                              color: Color(0xffd9d9d9),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: Color(0xff609966),
                                width: 5.0,
                              ),
                            ),
                          ),
                          // 후면 사진 표시 (동그란 모양)
                          Positioned(
                            top: 0, // 상단 위치
                            right: 0, // 오른쪽 위치
                            child: Container(
                              width: 90,
                              height: 120,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: NetworkImage(frontImageURL),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: Color(0xff609966),
                                  width: 5.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ]),
          ),
        ),
    );
  }
}
