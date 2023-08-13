import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flog/models/user.dart';
import 'package:flog/providers/user_provider.dart';
import 'package:flog/firebase_options.dart';
import 'package:flog/widgets/comment_card.dart';
import 'package:provider/provider.dart';


class FlogingDetailScreen extends StatefulWidget {
  final flogingId;
  final String status; // 전달받은 상태 정보 저장
  const FlogingDetailScreen({Key? key, required this.flogingId, required this.status}) : super(key: key);

  @override
  _FlogingDetailScreenState createState() => _FlogingDetailScreenState();
}

class _FlogingDetailScreenState extends State<FlogingDetailScreen> {
  final TextEditingController commentEditingController =
  TextEditingController();

  // 댓글 작성한 후 firebase에 저장하는 함수
  void postComment(String uid, String nickname, String profile) async {
    /*
    try {
      String res = await FireStoreMethods().postComment(
        widget.flogingId,
        commentEditingController.text,
        uid,
        nickname,
        profile,
      );

      if (res != 'success') {
        if (context.mounted) showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
     */
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 앱바 배경 색상
        elevation: 0, // 그림자 제거
        leading: IconButton(
          icon: Icon(
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
          children:[
            Image.asset(
              "assets/flog_logo.png",
              width: 55,
              height: 55,
            ),
            Text(
              "FLOGing",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xFF609966),
              ),
            ),
            SizedBox(height: 20), // 간격
            Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                color: Color(0xad747474),
                borderRadius: BorderRadius.circular(23), // 모서리 둥글기 조절
              ),
              child: Center(
                child: Text(
                  widget.status,
                  style: TextStyle(fontSize: 20, color: Colors.white),

                ),
              ),
            ),
        ]
      ),
    ),
      ),

          //CommentCard 에서 댓글 불러오기


          // 댓글 다는 필드
          bottomNavigationBar: SafeArea(
                child: Container(
                height: kToolbarHeight,
                margin:
                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.profile),
                      radius: 18,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: TextField(
                          controller: commentEditingController,
                          decoration: InputDecoration(
                            hintText: 'Comment as ${user.nickname}',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => postComment(
                        user.uid,
                        user.nickname,
                        user.profile,
                      ),
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: Image.asset(
                          'button/send_green.png', // 이미지의 경로나 소스를 지정해야 합니다.
                          width: 25, // 이미지의 가로 크기
                          height: 25, // 이미지의 세로 크기
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            );
  }
}
