import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flog/resources/firestore_methods.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:flog/widgets/comment_card.dart';


class FlogingDetailScreen extends StatefulWidget {
  final String flogingId;

  const FlogingDetailScreen(
      {Key? key, required this.flogingId,}) : super(key: key);

  @override
  _FlogingDetailScreenState createState() => _FlogingDetailScreenState();
}

class _FlogingDetailScreenState extends State<FlogingDetailScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String currentUserFlogCode = ""; // 현재 로그인한 사용자의 flogCode
  FireStoreMethods fireStoreMethods = FireStoreMethods();
  final _commentTextController = TextEditingController();

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

  Future<void> _showDeleteConfirmationDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'FLOGing 삭제',
            textAlign: TextAlign.left,
            style: GoogleFonts.nanumGothic(
              textStyle: TextStyle(
                fontSize: 20,
                color: Color(0xFF609966),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '이 FLOGing을 삭제하시겠습니까?',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.nanumGothic(
                    textStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('삭제'),
              onPressed: () async {
                try {
                  // Firebase에서 Floging 삭제
                  await FirebaseFirestore.instance
                      .collection('Floging')
                      .doc(widget.flogingId)
                      .delete();

                  Navigator.of(context).pop(); // 현재 다이얼로그 닫기

                  // 다이얼로그를 닫은 후 FlogingDetailScreen를 닫고 FlogingScreen을 엽니다.
                  Navigator.of(context).pop(); // FlogingDetailScreen 닫기

                } catch (e) {
                  Navigator.of(context).pop(); // 현재 다이얼로그 닫기

                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('오류 발생'),
                        content: Text('삭제 중에 오류가 발생했습니다.'),
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }


  // 텍스트 필드 클리어 및 키보드 숨김 함수
  void clearTextFieldAndHideKeyboard() {
    _commentTextController.clear();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }


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
                        fontSize: 15,
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
            actions: [
              Visibility(
                visible: (currentUser.email == flogData['uid']), // 삭제 권한이 있는 경우에만 버튼 표시
                child: IconButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    // "삭제" 팝업 다이얼로그를 표시
                    _showDeleteConfirmationDialog();
                  },
                ),
              ),
            ],
          ),
            body: SafeArea(
              child: Center(
              child: Column(
              children: [
                SizedBox(height: 20),
                Stack(
                children: <Widget>[
                  Container(
                  width: 260,
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(flogData['downloadUrl_back']),
                      fit: BoxFit.cover,
                    ),
                    color: Color(0xffd9d9d9),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                Positioned(
                  top:16,
                  right: 16,
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
                SizedBox(height:10),
                Divider(),
                SizedBox(height:10),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Floging')
                      .doc(flogingId)
                      .collection('Comment')
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, commentSnapshot) {
                    if (commentSnapshot.hasError) {
                      return Text('Error: ${commentSnapshot.error}');
                    }
                    if (commentSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    final commentDocuments = commentSnapshot.data!.docs;

                    if (commentDocuments.isEmpty) {
                      return Text(
                        '아직 댓글이 없습니다. 댓글을 달아보세요!',
                        style: GoogleFonts.nanumGothic(
                          textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    return Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: commentDocuments.map((commentDoc) {
                          final commentData = commentDoc.data() as Map<String, dynamic>;
                          final commentId = commentData['commentId'];
                          final text = commentData['text'];
                          final date = commentData['date'];
                          final uid = commentData['uid'];

                          return Column(
                            children: [
                              CommentCard(
                                date: date,
                                commentId: commentId,
                                text: text,
                                uid: uid,
                              ),
                              SizedBox(width: 10),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ]
            ),
            ),
            ),

          bottomNavigationBar: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("User")
                    .doc(currentUser.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // 데이터가 로드될 때까지 로딩 표시기 표시
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    if (snapshot.data == null || !snapshot.data!.exists) {
                      return const Text(
                          '데이터 없음 또는 문서가 없음'); // Firestore 문서가 없는 경우 또는 데이터가 null인 경우 처리
                    }
                    // 이제 snapshot.data을 안전하게 사용할 수 있음
                    Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
                    return SafeArea(
                      child: Container(
                        color: Colors.white,
                        height: kToolbarHeight,
                        margin:
                        EdgeInsets.only(bottom: MediaQuery
                            .of(context)
                            .viewInsets
                            .bottom),
                        padding: const EdgeInsets.only(left: 16, right: 8),
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
                                padding: const EdgeInsets.only(
                                    left: 16, right: 8),
                                child: TextField(
                                  controller: _commentTextController,
                                  decoration: InputDecoration(
                                    hintText: '${userData['nickname']}로 댓글 달기',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                await fireStoreMethods.postComment(
                                  widget.flogingId,
                                  _commentTextController.text,
                                  currentUser.uid,
                                );
                                clearTextFieldAndHideKeyboard();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                child: Image.asset(
                                  'button/send_green.png',
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                }
                ),
        );
        },
    );
  }
}