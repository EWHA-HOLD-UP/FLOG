import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'memorybox_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MemoryBoxValuabledayShowAllScreen extends StatefulWidget {
  const MemoryBoxValuabledayShowAllScreen({Key? key}) : super(key: key);

  @override
  _MemoryBoxValuabledayShowAllScreenState createState() =>
      _MemoryBoxValuabledayShowAllScreenState();
}

class _MemoryBoxValuabledayShowAllScreenState
    extends State<MemoryBoxValuabledayShowAllScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String currentUserFlogCode = "";

  @override
  void initState() {
    super.initState();
    getUserFlogCode();
  }

  //현재 로그인한 사용자의 flogCode를 Firestore에서 가져오는 함수
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SizedBox(width: 95),
            Text(
              '소중한 날',
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 25),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Qpuzzle')
                      .where('flogCode', isEqualTo: currentUserFlogCode)
                      .where('isComplete', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    final docs = snapshot.data?.docs ?? [];

                    if (docs.isEmpty) {
                      return Center(
                        child: Text(
                          '완성된 소중한 날이 아직 없어요.\n\n어서 큐퍼즐을 완성해보세요!',
                          style: GoogleFonts.nanumGothic(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black38,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2.0 / 3.0,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final imagePath = docs[index]['pictureUrl'];
                        final puzzlenumber = docs[index]['puzzleNo'];

                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.white, width: 1.5),
                                color: const Color(0xFFCED3CE),
                                image: DecorationImage(
                                  image: NetworkImage(imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Color(0x99ffffff),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '#$puzzlenumber',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


