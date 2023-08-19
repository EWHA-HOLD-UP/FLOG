import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class QpuzzleScreen extends StatefulWidget {

  const QpuzzleScreen({Key? key}) : super(key: key);

  @override
  State<QpuzzleScreen> createState() => _QpuzzleScreenState();
}

class _QpuzzleScreenState extends State<QpuzzleScreen> {
  XFile? image;
  List<bool> unlockStates = List.generate(6, (index) => false); // 6개의 조각에 대한 잠금 상태를 나타내는 리스트
  int selectedCellIndex = -1; // 선택된 셀의 인덱스
  bool isAnswered = false;
  bool isQuestionSheetShowed = false;

  Map<int, String> status = {
    0: "아직 답변을 작성하지 않았어요.",
    1: "답변을 작성한 후 확인하세요.",
    2: "답변 작성하기", //'나'인 경우
  };

  List<int> memberStatus = [0, 1, 2]; //임의로 지정! 구성원들의 상태 넣기

  String myanswer = ''; //내 답변 저장할 변수

  void onPickImage() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery);
    final cropped_image = await ImageCropper()
        .cropImage(sourcePath: image!.path, aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 3));

    setState(() {
      this.image = XFile(cropped_image!.path);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Image.asset(
                "assets/flog_logo.png",
                width: 55,
                height: 55,
              ),
              Text(
                "Q-puzzle",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF609966), // #609966 색상 지정
                ),
              ),
              SizedBox(height: 20), // 간격
              Center(
                  child: renderBody()
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderBody() {
    if (image != null) {
      return Stack(
        children: [
          Container(
            width: 330,
            height: 495,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(image!.path)),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(23),
            ),
          ),
          Container(
            width: 330,
            height: 495,
            child: Column(
              children: [
                for (int row = 0; row < 3; row++)
                  Row(
                    children: [
                      for (int col = 0; col < 2; col++)
                        GestureDetector(
                          onTap: () {
                            if (!unlockStates[row * 2 + col] && isQuestionSheetShowed == false || selectedCellIndex == row * 2 + col) {
                              //한 번 어떤 퍼즐의 QuestionSheet 봤으면 대답 누르고 확인 누르기 전에 다른 조각 열람 불가 , 그러나 선택했던 조각이라면 QuestionSheet 봤어도 다시 클릭가능
                              setState(() {
                                selectedCellIndex = row * 2 + col;
                              });
                            showQuestionSheet(context);
                          }
                          },
                          child: Container(
                            width: 165,
                            height: 165,
                            decoration: BoxDecoration(
                              color: unlockStates[row * 2 + col]
                                  ? Colors.transparent
                                  : Color(0xFF000000), //검정색 조각으로 덮음
                              border: Border.all(
                                color: unlockStates[row * 2 + col]
                                    ? Color(0xFF609966)
                                    : Colors.white, // 흰색 테두리
                                width: 2.0,
                              ),

                              // 둥근 테두리
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    (row == 0 && col == 0) ? 23.0 : 0.0), // 1행1열
                                topRight: Radius.circular(
                                    (row == 0 && col == 1) ? 23.0 : 0.0), // 1행2열
                                bottomLeft: Radius.circular(
                                    (row == 2 && col == 0) ? 23.0 : 0.0), // 3행1열
                                bottomRight: Radius.circular(
                                    (row == 2 && col == 1) ? 23.0 : 0.0), // 3행2열
                              ),
                          ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if(selectedCellIndex == row * 2 + col && unlockStates[row * 2 + col] == false)
                                  Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xFF609966),
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                (row == 0 && col == 0) ? 23.0 : 0.0), // 1행1열
                                            topRight: Radius.circular(
                                                (row == 0 && col == 1) ? 23.0 : 0.0), // 1행2열
                                            bottomLeft: Radius.circular(
                                                (row == 2 && col == 0) ? 23.0 : 0.0), // 3행1열
                                            bottomRight: Radius.circular(
                                                (row == 2 && col == 1) ? 23.0 : 0.0), // 3행2열
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Image.asset(
                                          "assets/flog_foot_green.png",
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                        ),

                      )
                    ],
                  ),
              ],
            ),
          ),
        ],
      );
    }
    else {
      return Container(
        width: 330,
        height: 495,
        decoration: BoxDecoration(
          color: Color(0xad747474),
          borderRadius: BorderRadius.circular(23), // 모서리 둥글기 조절
        ),
        child: Center(
          child: InkWell(
            onTap: () {
              onPickImage();
            },
            child: Image.asset(
                "button/plus.png",
                width: 30,
                height: 30
            ),
          ),
        ),
      );
    }
  }
  void showQuestionSheet(BuildContext context){
    isQuestionSheetShowed=true;
    showModalBottomSheet(
        context: context,
        backgroundColor: Color(0xFF96B785),
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)), // 위쪽 모서리 둥글게 지정
        ),
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView(
              children: [
                Column(
                  children: [
                    SizedBox(height: 25),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Image.asset(
                          "assets/flog_logo.png",
                          width: 55,
                          height: 55,
                          alignment: Alignment.centerLeft,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20), // 왼쪽과 오른쪽 간격을 지정
                        child: Text(
                          'Q${selectedCellIndex}. 가족들에게 어쩌구 저쩌구 어쩌구 저쩌구 줄바꿈 테스트! 데이터베이스에서 $selectedCellIndex번 질문 따오기',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          softWrap: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(), // 스크롤을 비활성화
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int rowIndex) {
                        return GestureDetector(
                          onTap: () {
                            if(memberStatus[rowIndex] == 2){
                              showAnswerSheet(context);
                            }
                          },
                          child : Container(
                              width: double.infinity,
                              height: 80, // 높이 설정
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Row(
                                //프로필 사진
                                children: [
                                  SizedBox(width: 10),
                                  Container(
                                    width: 60, // 컨테이너의 너비
                                    height: 60, // 컨테이너의 높이
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle, // 원 모양의 컨테이너를 만듭니다.
                                      color: Colors.grey[200], // 컨테이너의 배경색
                                    ),
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50), // 원 모양의 프로필 이미지를 위한 경계를 설정합니다.
                                        child: Image.asset(
                                          "assets/flog_logo.png",
                                          width: 55,
                                          height: 55,
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    children: [
                                      SizedBox(height: 15),
                                      Text(
                                        textAlign: TextAlign.left,
                                        '사용자 ${rowIndex}',
                                        style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '${status[memberStatus[rowIndex]]}',
                                        style: TextStyle(fontSize: 13, color: Colors.white,),

                                      )
                                    ],
                                  )

                                ],
                              ),
                            ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),

          );

        }
    );
  }

  void showAnswerSheet(BuildContext context){
    showModalBottomSheet(
        context: context,
        backgroundColor: Color(0xFF434343),
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)), // 위쪽 모서리 둥글게 지정
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
              },
              child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 15),
                            Row(
                              children: [
                                SizedBox(width: 350),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isAnswered = true;
                                      unlockStates[selectedCellIndex] = true; // 답변한 셀을 unlock 상태로 변경
                                      isQuestionSheetShowed = false;
                                    });
                                    Navigator.pop(context); // 모달 닫기
                                    print(myanswer); //내 답변 저장되는 것 확인용 -> 나중에 파이어베이스에 넣었다가 불러오면 되지 않을까??
                                  },
                                  child: Image.asset(
                                      "button/send_white.png",
                                      width: 30,
                                      height: 30
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 10),
                                Image.asset(
                                  "assets/flog_logo.png",
                                  width: 55,
                                  height: 55,
                                  alignment: Alignment.centerLeft,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20), // 왼쪽과 오른쪽 간격을 지정
                                child: Text(
                                  'Q${selectedCellIndex}. 가족들에게 어쩌구 저쩌구 어쩌구 저쩌구 줄바꿈 테스트! 데이터베이스에서 $selectedCellIndex번 질문 따오기',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  softWrap: true,
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                            Row(
                              children: [
                                SizedBox(width: 10),
                                Container(
                                  width: 60, // 컨테이너의 너비
                                  height: 60, // 컨테이너의 높이
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle, // 원 모양의 컨테이너를 만듭니다.
                                    color: Colors.grey[200], // 컨테이너의 배경색
                                  ),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50), // 원 모양의 프로필 이미지를 위한 경계를 설정합니다.
                                      child: Image.asset(
                                        "assets/flog_logo.png",
                                        width: 55,
                                        height: 55,
                                        alignment: Alignment.centerLeft,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Text(
                                  textAlign: TextAlign.left,
                                  '사용자 2 - Me',
                                  style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ]
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                style: TextStyle(color: Colors.white),
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  hintText: '답변 쓰기...',
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none
                                  )
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    myanswer = text;
                                  });
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
            ),
          );
        }
    );
  }
}