import 'dart:math' as math;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flog/notification/local_notification.dart';
import 'package:flog/screen/root_screen.dart';
import 'package:flog/widgets/ImageSticker/sticker_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'dart:ui' as ui;
import '../../resources/firestore_methods.dart';
import '../../widgets/ImageSticker/image_sticker.dart';
import '../../widgets/ImageSticker/sticker_model.dart';

//💚💚182라인 finalbackImage, 240라인 finalfrontImage가 최종적으로 스티커까지 붙은 이미지
// --> 파이어베이스로 넘기면 됨! Uint8List 형식의 변수로 되어있음

class ShootingEditScreen extends StatefulWidget {
  final String backImagePath;
  final String frontImagePath;

  const ShootingEditScreen({
    Key? key,
    required this.backImagePath,
    required this.frontImagePath,
  }) : super(key: key);

  @override
  ShootingEditState createState() => ShootingEditState();
}

class ShootingEditState extends State<ShootingEditScreen> {
  Set<StickerModel> frontImageStickers = {}; //전면 카메라에 붙인 스티커 저장
  Set<StickerModel> backImageStickers = {}; //후면 카메라에 붙인 스티커 저장
  bool isSendingButtonEnabled = false; //상태전송버튼 활성화 여부 설정 위한 부분
  bool isFrontImageVisible = false; //후면 -> 전면 플립 기능 위한 부분
  String? selectedId; //스티커 선택하여 붙일 때 사용할 스티커 아이디
  GlobalKey globalKey = GlobalKey(); //스티커 포함하여 캡처하기 위한 global key
  Uint8List finalbackImage =
      Uint8List(0); //스티커까지 붙인 후면 카메라 저장할 변수 초기화 (초기 크기가 0인 빈 Uint8List)
  Uint8List finalfrontImage =
      Uint8List(0); //스티커까지 붙인 전면 카메라 저장할 변수 초기화 (초기 크기가 0인 빈 Uint8List)
  TextEditingController _textEditingController = TextEditingController();
  String caption = '';

  void postImage(String uid, String flogCode) async {
    try {
      // upload to storage and db
      String res = await FireStoreMethods()
          .uploadFloging(finalfrontImage, finalbackImage, uid, flogCode, caption);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //뒤로가기 방지
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Floging',
            style: GoogleFonts.balooBhaijaan2(
              textStyle: TextStyle(
                fontSize: 30,
                color: Color(0xFF609966),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          elevation: 0.0, //그림자 없음
          centerTitle: true,
        ),
        body: Center(
          child: SafeArea(
            child: Column(
              children: [
                /*---사진을 보여주는 부분---*/
                showPicture(), //1️⃣사진을 보여주는 부분
                const SizedBox(height: 10), //간격
                /*---캡션을 보여주는 부분---*/
               GestureDetector(
                 child: Container(
                   width: 350,
                   decoration: BoxDecoration(
                       color: Color(0xFFD1E0CA),
                       borderRadius: BorderRadius.circular(15)
                   ),
                   child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Center(
                         child: Text(
                           caption,
                           style: GoogleFonts.balooBhaijaan2(
                             textStyle: TextStyle(
                               fontSize: 15,
                             ),
                           ),
                         ),
                       )
                   ),
                 ),
                 onTap: _showTextEditingDialog
               ),
                /*---텍스트 스티커, 플립, 이미지 스티커 버튼---*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textButton(), //2️⃣텍스트 버튼
                    const SizedBox(width: 50),
                    flipButton(), //3️⃣사진 전환 버튼
                    const SizedBox(width: 50),
                    imageStickerButton(), //4️⃣이미지 스티커 버튼
                    const SizedBox(width: 50),
                    stickerUndoButton(), //5️⃣스티커 뒤로가기 버튼
                  ],
                ),
                const SizedBox(height: 10),

                /*---상태 전송 버튼---*/
                sendingButton(), //6️⃣상태 전송 버튼
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*-----------------------------위젯-----------------------------*/
  // 1️⃣사진을 보여주는 부분
  Widget showPicture() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: 345,
            height: 458,
            child: RepaintBoundary(
              //스티커 포함하여 현재 화면 캡처
              key: globalKey,
              child: Stack(
                children: [
                  Visibility(
                    visible: !isFrontImageVisible, //전면 사진이 안 보이게
                    child: Image.file(
                      File(widget.backImagePath), //Shooting_screen_back 화면에서 받아온 후면 사진 불러오기
                      width: 360,
                      height: 520,
                    ),
                  ),
                  ...backImageStickers.map(
                    //후면 카메라에 붙인 스티커 저장
                        (sticker) => Center(
                      child: ImageSticker(
                        key: ObjectKey(sticker.id),
                        onTransform: () {
                          onTransform(sticker.id);
                        },
                        imgPath: sticker.imgPath,
                        isSelected: selectedId == sticker.id,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isFrontImageVisible, //전면 사진이 보이게
                    child: Transform(
                      //좌우 반전
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Image.file(
                        File(widget.frontImagePath), //Shooting_screen_front 화면에서 받아온 후면 사진 불러오기
                        width: 360,
                        height: 520,
                      ),
                    ),
                  ),
                  ...frontImageStickers.map(
                    //전면 카메라에 붙인 스티커 저장
                        (sticker) => Center(
                      child: ImageSticker(
                        key: ObjectKey(sticker.id),
                        onTransform: () {
                          onTransform(sticker.id);
                        },
                        imgPath: sticker.imgPath,
                        isSelected: selectedId == sticker.id,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // 모서리 둥글게
                    ),
                    title: Text(
                      '메인 화면으로 돌아가시겠습니까?',
                      style: GoogleFonts.nanumGothic(
                        textStyle: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF609966),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    content: Text(
                      '메인으로 돌아가면\n방금 찍은 사진들은 복구할 수 없어요!\n',
                      style: GoogleFonts.nanumGothic(
                        textStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0), // 모서리를 둥글게 설정
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF609966)),
                            ),
                            child: Text(
                              '취소',
                              style: GoogleFonts.nanumGothic(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              '확인',
                              style: GoogleFonts.nanumGothic(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0), // 모서리를 둥글게 설정
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF609966)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Image.asset(
                  "button/close.png",
                  width: 15,
                  height: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 2️⃣텍스트 버튼
  Widget textButton() {
    return InkWell(
      onTap: () {
        _showTextEditingDialog();
      },
      child: Image.asset("button/text.png", width: 30, height: 30),
    );
  }

  // 3️⃣플립 버튼
  Widget flipButton() {
    return InkWell(
      onTap: () async {
        //플립 버튼을 누르면
        if (isFrontImageVisible == false) {
          //후면일 때만 (후면->전면 플립은 가능하지만 전면->후면 다시 넘어가서 꾸밀 수 없음)
          setState(() {
            isFrontImageVisible = true; //후면->전면 (전면이 후면 위에 stack되어 보이도록)
            isSendingButtonEnabled = true; //전면으로 전환 후 비로소 상태 전송 버튼 활성화
          });

          RenderRepaintBoundary boundary = globalKey.currentContext!
              .findRenderObject() as RenderRepaintBoundary;
          ui.Image image = await boundary.toImage();
          ByteData? byteData =
              await image.toByteData(format: ui.ImageByteFormat.png);

          if (byteData != null) {
            Uint8List pngBytes = byteData.buffer
                .asUint8List(); //지금까지 꾸민 스티커와 후면카메라를 캡처하여 pngBytes에 임시 저장
            finalbackImage =
                pngBytes; //최종적으로 finalbackImage에 저장 --> 이걸 파이어베이스에 넘기면 됨
          }
        }
      },
      child: isFrontImageVisible
          ? Image.asset(
              //전면카메라일 때
              "button/flip_disabled.png", // 비활성화된 버튼 이미지
              width: 30,
              height: 30,
            )
          : Image.asset(
              //후면카메라일 때
              "button/flip.png", // 활성화된 버튼 이미지
              width: 30,
              height: 30,
            ),
    );
  }

  // 4️⃣이미지 스티커 버튼
  Widget imageStickerButton() {
    return InkWell(
      onTap: () {
        _showStickerPicker(context); //클릭 시 이미지 스티커 목록을 보여줌
      },
      child: Image.asset("button/sticker.png", width: 30, height: 30),
    );
  }

  // 5️⃣ 스티커 뒤로가기 버튼
  Widget stickerUndoButton() {
    return IconButton(
      onPressed: () {
        undoSticker(); //클릭 시 되돌리기
      },
      icon: const Icon(
        Icons.undo, //추후에 undo 버튼 제작하여 변경?
        color: Color(0xFF609966),
      ),
    );
  }

  // 6️⃣상태 전송 버튼
  Widget sendingButton() {
    return ElevatedButton(
      //상태 전송 버튼을 누르면
      onPressed: isSendingButtonEnabled
          ? () async {
              //상태 전송 버튼이 활성화 되어야 할 때 (=전면으로 바뀌었을 때)
              RenderRepaintBoundary boundary = globalKey.currentContext!
                  .findRenderObject() as RenderRepaintBoundary;
              ui.Image image = await boundary.toImage();
              ByteData? byteData =
                  await image.toByteData(format: ui.ImageByteFormat.png);

              if (byteData != null) {
                Uint8List pngBytes = byteData.buffer
                    .asUint8List(); // 지금까지 꾸민 스티커와 전면카메라를 캡처하여 pngBytes에 임시 저장
                finalfrontImage =
                    pngBytes; //최종적으로 finalfrontImage에 저장 --> 이걸 파이어베이스에 넘기면 됨
              }

              final currentUser = FirebaseAuth.instance.currentUser!;
              final usersCollection =
                  FirebaseFirestore.instance.collection("User");
              final groupCollection =
                  FirebaseFirestore.instance.collection("Group");
              DocumentSnapshot userDocument =
                  await usersCollection.doc(currentUser.email).get();
              if (userDocument.exists) {
                String flogCode = userDocument.get('flogCode');
                postImage(currentUser.email!, flogCode);
                DocumentSnapshot groupDocument =
                    await groupCollection.doc(flogCode).get();
                if (groupDocument.exists) {
                  int frog = groupDocument.get('frog');
                  frog = frog + 1;
                  await groupCollection.doc(flogCode).update({'frog': frog});
                }
              }

              LocalNotification.showNotification(
                  userToken: userDocument.get('token'),
                  context: context,
                  title: '[FLOGing]',
                  message: 'FLOGing 상태를 업로드했습니다 !');

              if (!mounted) return;
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            }
          : null, //상태 전송 버튼이 활성화 되지 않았을 때 (=후면 사진이 나타나있을 때) 버튼을 눌러도 아무것도 x

      //상태 전송 버튼 디자인
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // 둥근 모서리 설정
          ),
          fixedSize: const Size(180, 55),
          backgroundColor: const Color(0xff609966)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("button/send_white.png", height: 20, width: 20),
          const SizedBox(width: 20),
          Text(
            '상태 전송',
            style: GoogleFonts.nanumGothic(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*-----------------------------함수-----------------------------*/
  //이미지 스티커 목록을 보여줌
  void _showStickerPicker(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            AlertDialog(
              backgroundColor: Colors.transparent,
              content: StickerPicker(onStickerTap: onStickerTap),
            ),
            Positioned(
              top: 260, // 상단에 배치
              left: 60, // 왼쪽에 배치
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // AlertDialog 닫기
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD1E0CA),
                  ),
                  child: Center(
                    child: Image.asset(
                      "button/close.png",
                      width: 15,
                      height: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  //이미지 스티커 목록에서 스티커를 눌렀을 때 붙인 스티커 목록에 스티커 추가함
  void onStickerTap(int index) async {
    setState(() {
      if (isFrontImageVisible) {
        //전면 카메라가 보일 때
        frontImageStickers.add(
          //전면 카메라에 붙인 스티커 목록에 해당 스티커 추가
          StickerModel(
            id: const Uuid().v4(),
            imgPath: 'assets/emoticons/emoticon_$index.png',
          ),
        );
      } else {
        //후면 카메라가 보일 때
        backImageStickers.add(
          //후면 카메라에 붙인 스티커 목록에 해당 스티커 추가
          StickerModel(
            id: const Uuid().v4(),
            imgPath: 'assets/emoticons/emoticon_$index.png',
          ),
        );
      }
    });
  }

  //스티커 크기, 위치 변형
  void onTransform(String id) {
    setState(() {
      selectedId = id;
    });
  }

  //스티커 되돌리기
  void undoSticker() async {
    if (!isFrontImageVisible && backImageStickers.isNotEmpty) {
      setState(() {
        StickerModel lastStickerback = backImageStickers.last;
        backImageStickers.remove(lastStickerback);
        backImageStickers
            .removeWhere((sticker) => sticker.id == lastStickerback.id);
      });
    } else if (isFrontImageVisible && frontImageStickers.isNotEmpty) {
      setState(() {
        StickerModel lastStickerfront = frontImageStickers.last;
        frontImageStickers.remove(lastStickerfront);
        frontImageStickers
            .removeWhere((sticker) => sticker.id == lastStickerfront.id);
      });
    }
  }

  void _showTextEditingDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0), // 모서리 둥글게
            ),
            title: Text(
              '가족에게 한 마디!',
              style: TextStyle(
                color: Color(0xFF609966),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _textEditingController,
                  maxLength: 25,
                  decoration: InputDecoration(
                      hintText: '클릭하여 작성하기...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF609966)),
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          caption = _textEditingController.text;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        '확인',
                        style: GoogleFonts.balooBhaijaan2(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0), // 모서리를 둥글게 설정
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF609966)),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0), // 모서리를 둥글게 설정
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF609966)),
                      ),
                      child: Text(
                        '취소',
                        style: GoogleFonts.balooBhaijaan2(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
    );
  }
}
