import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

//💚💚478라인 myanswer가 해당 조각에 단 답변 저장된 곳
//모든 조각의 답변이 이곳에 저장되므로 조각이 바뀌기 전에 파이어베이스로 넘겨서 저장해야 함 or 리스트 형식으로 myanswer를 바꾸는게 좋을지..?
//--> 파이어베이스로 넘기면 됨!

class QpuzzleScreen extends StatefulWidget {
  const QpuzzleScreen({Key? key}) : super(key: key);

  @override
  State<QpuzzleScreen> createState() => _QpuzzleScreenState();
}

class _QpuzzleScreenState extends State<QpuzzleScreen> {
  XFile? image; //불러온 이미지 저장할 변수
  List<bool> unlockStates =
      List.generate(6, (index) => false); //6개의 조각에 대한 잠금 상태를 나타내는 리스트
  int selectedCellIndex = -1; //선택된 셀의 인덱스 : 초기값은 -1
  bool isQuestionSheetShowed = false; //질문창을 이미 조회했는지(조각을 선택했는지)
  bool isAnswered = false; //답변 했는지
  //💚나중에 다른 사용자들의 답변 여부도 파이어베이스에서 불러와야함

  String myanswer = ''; //내 답변 저장할 변수

  //안내메시지 - 추후 코드 수정 필요
  Map<int, String> status = {
    0: "아직 답변을 작성하지 않았어요.",
    1: "답변을 작성한 후 확인하세요.",
    2: "답변 작성하기", //'나'인 경우
  };

  //구성원들의 상태를 저장 - 현재 임의로 지정
  List<int> memberStatus = [0, 1, 2];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*---상단 Q-puzzle 바---*/
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const SizedBox(width: 50),
            Image.asset(
              "assets/flog_logo.png",
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 10),
            Text('Q-puzzle',
                style: GoogleFonts.balooBhaijaan2(
                    textStyle: TextStyle(
                  fontSize: 30,
                  color: Color(0xFF609966),
                  fontWeight: FontWeight.bold,
                ))),
          ],
        ),
        elevation: 0.0, //그림자 없음
        centerTitle: true,
      ),
      backgroundColor: Colors.white, //화면 배경색
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              /*---퍼즐을 보여주는 부분---*/
              Center(child: puzzleBody()),
            ],
          ),
        ),
      ),
    );
  }

  /*-----------------------------위젯-----------------------------*/
  Widget puzzleBody() {
    if (image != null) {
      //이미지가 선택되었다면
      return Stack(
        children: [
          puzzleImage(), //앨범에서 선택한 사진을 하단에 깔고

          //그 위를 분할하여 덮고 unlock하기
          SizedBox(
            width: 330,
            height: 495,
            child: Column(
              children: [
                for (int row = 0; row < 3; row++) //3행
                  Row(
                    children: [
                      for (int col = 0; col < 2; col++) //2열
                        GestureDetector(
                          onTap: () {
                            if (!unlockStates[row * 2 + col] &&
                                    isQuestionSheetShowed == false ||
                                selectedCellIndex == row * 2 + col) {
                              //한 번 어떤 퍼즐의 QuestionSheet 봤으면 대답 누르고 확인 누르기 전에 다른 조각 열람 불가
                              //그러나 선택했던 조각이라면 QuestionSheet 봤어도 다시 클릭 가능
                              if (selectedCellIndex != row * 2 + col) {
                                //만약 새로운 조각 클릭 시,
                                isAnswered =
                                    false; //해당 조각의 질문은 아직 작성되지 않았으므로 다시 false로 초기화
                              }
                              setState(() {
                                selectedCellIndex = row * 2 + col;
                              });
                              // 0 1
                              // 2 3
                              // 4 5
                              //형태로 조각 인덱싱하고, 해당 조각 클릭시 인덱스를 저장
                              showQuestionSheet(context); //질문창 나타나기
                            }
                          },
                          child: Container(
                            //분할된 조각
                            width: 165,
                            height: 165,
                            decoration: BoxDecoration(
                              color: unlockStates[row * 2 + col]
                                  ? Colors.transparent //unlock되면 투명해져서 사진이 드러남
                                  : const Color(
                                      0xFF000000), //unlock되지 않았으면 검정색 조각으로 덮음
                              border: Border.all(
                                //테두리
                                color: unlockStates[row * 2 + col]
                                    ? const Color(0xFF609966) //unlock되면 초록 테두리
                                    : Colors.white, //unlock되지 않았으면 흰색 테두리
                                width: 2.0, //테두리 두께
                              ),
                              borderRadius: BorderRadius.only(
                                //둥근 테두리 설정
                                topLeft: Radius.circular((row == 0 && col == 0)
                                    ? 23.0
                                    : 0.0), // 1행 1열 - 좌측 상단 모서리
                                topRight: Radius.circular((row == 0 && col == 1)
                                    ? 23.0
                                    : 0.0), // 1행 2열 - 우측 상단 모서리
                                bottomLeft: Radius.circular(
                                    (row == 2 && col == 0)
                                        ? 23.0
                                        : 0.0), // 3행 1열 - 좌측 하단 모서리
                                bottomRight: Radius.circular(
                                    (row == 2 && col == 1)
                                        ? 23.0
                                        : 0.0), // 3행 2열 - 우측 하단 모서리
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                //현재 진행 중인 조각이면 - 선택된 조각이 아직 unlock되지 않았고 선택한 조각이면
                                if (selectedCellIndex == row * 2 + col &&
                                    unlockStates[row * 2 + col] == false)
                                  Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            //초록 테두리
                                            color: const Color(0xFF609966),
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            //둥근 모서리
                                            topLeft: Radius.circular(
                                                (row == 0 && col == 0)
                                                    ? 23.0
                                                    : 0.0), // 1행 1열
                                            topRight: Radius.circular(
                                                (row == 0 && col == 1)
                                                    ? 23.0
                                                    : 0.0), // 1행 2열
                                            bottomLeft: Radius.circular(
                                                (row == 2 && col == 0)
                                                    ? 23.0
                                                    : 0.0), // 3행 1열
                                            bottomRight: Radius.circular(
                                                (row == 2 && col == 1)
                                                    ? 23.0
                                                    : 0.0), // 3행 2열
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Image.asset(
                                          //발자국 표시
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
    } else {
      //이미지가 아직 선택되지 않았다면
      return Container(
        width: 330,
        height: 495,
        decoration: BoxDecoration(
          color: const Color(0xad747474), //회색 상자
          borderRadius: BorderRadius.circular(23), //둥근 모서리
        ),
        child: Center(
          child: InkWell(
            //+버튼 누르면 앨범에서 사진 선택 가능
            onTap: () {
              onPickImage(); //갤러리에서 사진 선택하여 불러오는 함수
            },
            child: Image.asset("button/plus.png", //추후에 이미지+ 버튼 제작하여 변경?
                width: 30,
                height: 30),
          ),
        ),
      );
    }
  }

  /*-----------------------------위젯 속 위젯-----------------------------*/
  //앨범에서 선택한 사진
  Widget puzzleImage() {
    return Container(
      width: 330,
      height: 495,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(File(image!.path)),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(23),
      ),
    );
  }

  /*-----------------------------함수-----------------------------*/
  //갤러리에서 사진 선택하여 불러오는 함수
  void onPickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    final croppedImage = await ImageCropper() //2:3 비율로 크롭
        .cropImage(
            sourcePath: image!.path,
            aspectRatio: const CropAspectRatio(ratioX: 2, ratioY: 3));
    setState(() {
      this.image = XFile(croppedImage!.path);
    });
  }

  //질문창 나타나게 하는 함수
  void showQuestionSheet(BuildContext context) {
    isQuestionSheetShowed = true; //질문창이 나타나면 해당 변수 boolean값 true로 변경
    if (isAnswered == true) {
      isQuestionSheetShowed = false;
    } //다음 조각을 위해 false로 초기화
    showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFF96B785), //질문창 배경색
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          //위쪽 둥근 모서리
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7, //전체 화면의 70% 덮는 크기
            child: ListView(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Image.asset(
                          "assets/flog_logo.png",
                          width: 55,
                          height: 55,
                          alignment: Alignment.centerLeft,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    /*---질문---*/
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20), //왼쪽과 오른쪽 간격 지정
                        child: Text(
                          //💚 DB에서 인덱스 활용하여 질문 따오기
                          'Q$selectedCellIndex. 가족들에게 어쩌구 저쩌구 어쩌구 저쩌구 줄바꿈 테스트! 데이터베이스에서 $selectedCellIndex번 질문 따오기',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          softWrap: true, //자동 줄바꿈
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), //스크롤을 비활성화
                      itemCount: 3, //가족 수 - 💚 나중에 파이어베이스에서 받아오기
                      itemBuilder: (BuildContext context, int rowIndex) {
                        return GestureDetector(
                          onTap: () {
                            if (memberStatus[rowIndex] == 2 &&
                                isAnswered == false) {
                              //'나'의 박스: '답변 작성하기' 부분을 클릭하면
                              showAnswerSheet(context); //답변창 나타남
                            }
                          },
                          child: Container(
                            //구성원 각각의 답변 상태 or 답변이 나타나는 상자
                            width: double.infinity,
                            height: 80, //높이 설정
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromRGBO(0, 0, 0, 0.5),
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle, //원 모양 - 프로필 사진
                                    color: Colors.grey[200], //배경색
                                  ),
                                  child: Center(
                                    //💚 나중에 사람마다 다른 프사로 받아와서 띄울 수 있게 수정하기
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(50), //경계
                                      child: Image.asset(
                                        //프로필 사진 💚 나중에 파이어베이스에서 받아오기
                                        "assets/flog_logo.png", //현재는 모두 개구리로 임의로 사진 파일 넣어둠
                                        width: 55,
                                        height: 55,
                                        alignment: Alignment.centerLeft,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  children: [
                                    const SizedBox(height: 15),
                                    Text(
                                      textAlign: TextAlign.left,
                                      '사용자 $rowIndex', //사용자 이름 💚 나중에 파이어베이스에서 받아오기
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      !isAnswered
                                          ? '${status[memberStatus[rowIndex]]}' //아직 내가 답변 안 했으면 구성원 상태별 안내메시지 띄우기
                                          : '사용자 $rowIndex의 답변', //내가 답변했으면 구성원들의 답변 띄우기 💚 나중에 파이어베이스에서 받아오기
                                      //myanswer도 안 넣은 이유는 나중에 리스트형태로 answer[사용자 index]이런식으로 받아오기 위함
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  //답변창 나타나게 하는 함수
  void showAnswerSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFF434343), //답변창 배경색
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20.0)), //위쪽 둥근 모서리
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.7, //전체 화면의 70% 덮는 크기
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const SizedBox(width: 350),
                              InkWell(
                                //💥 나중에 아무것도 안 쓰면 전송 버튼 못 누르도록 수정 필요
                                onTap: () {
                                  setState(() {
                                    isAnswered = true; //전송버튼 누르면 답변한 것으로
                                    unlockStates[selectedCellIndex] =
                                        true; //답변한 조각을 unlock 상태로 변경
                                  });
                                  Navigator.pop(context); //답변창 닫기
                                  Navigator.pop(context); //질문창 닫기
                                  showQuestionSheet(
                                      context); //질문창 띄우기 - 답변 새로고침 위함
                                  print(myanswer); //💥 내 답변 잘 저장되는지 확인용
                                  //💚나중에 파이어베이스에 넣었다가 다른 구성원 답변들과 함께 리스트에 저장하여 불러오기
                                },
                                child: Image.asset(
                                    //전송 버튼
                                    "button/send_white.png",
                                    width: 30,
                                    height: 30),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 10),
                              Image.asset(
                                "assets/flog_logo.png",
                                width: 55,
                                height: 55,
                                alignment: Alignment.centerLeft,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                //💚 DB에서 인덱스 활용하여 질문 따오기
                                'Q$selectedCellIndex. 가족들에게 어쩌구 저쩌구 어쩌구 저쩌구 줄바꿈 테스트! 데이터베이스에서 $selectedCellIndex번 질문 따오기',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                softWrap: true, //자동 줄바꿈
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Row(children: [
                            const SizedBox(width: 10),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, //프로필 사진
                                color: Colors.grey[200], //기본 그레이 배경
                              ),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50), //경계
                                  child: Image.asset(
                                    //내 프로필 사진 - 💚 나중에 파이어베이스에서 가져오기
                                    "assets/flog_logo.png",
                                    width: 55,
                                    height: 55,
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Text(
                              //내 이름 - 💚 나중에 파이어베이스에서 가져오기
                              textAlign: TextAlign.left,
                              '사용자 2 - Me',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              //답변 입력창
                              style: const TextStyle(color: Colors.white),
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                  hintText: '답변 쓰기...', //힌트 문구
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                              onChanged: (text) {
                                setState(() {
                                  myanswer = text; //입력한 내용을 myanswer 변수에 저장
                                  //💚💚💚 파이어베이스로 넘기기
                                });
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )),
          );
        });
  }
}
