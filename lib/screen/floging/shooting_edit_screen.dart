import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flog/screen/floging/floging_screen.dart';
import 'package:flog/screen/floging/ttt.dart';
import 'package:flog/screen/root_screen.dart';
import 'package:flog/widgets/ImageSticker/sticker_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

import '../../widgets/ImageSticker/ImageSticker.dart';
import '../../widgets/ImageSticker/sticker_model.dart';
import 'floging_detail_screen.dart';


class ShootingEditScreen extends StatefulWidget {
  final String backImagePath;
  final String frontImagePath;

  const ShootingEditScreen({
    Key? key,
    required this.backImagePath,
    required this.frontImagePath,
  }) : super(key: key);

  @override
  _ShootingEditState createState() => _ShootingEditState();
}

class _ShootingEditState extends State<ShootingEditScreen> {
  Set<StickerModel> frontImageStickers = {}; //셀카 스티커
  Set<StickerModel> backImageStickers = {}; //후면 카메라 스티커
  GlobalKey globalKey = GlobalKey();
  bool isSendingButtonEnabled = false;
  bool isFrontImageVisible = false; //플립 기능 위한 부분
  String? selectedId;


  /*
  bool isStickerbuttonPressed = false;
  Set<ImageStickerModel> Backstickers = {};
  String? selectedId;
  */
  Uint8List final_backImagePath = Uint8List(0);
  Uint8List final_frontImagePath = Uint8List(0);

  @override
  Widget build(BuildContext context) {
    return WillPopScope( //뒤로가기 해서 사진 다시 찍는 것 막음
      onWillPop: () async => false,
      child:
      Scaffold(
        body: Center(
          child: SafeArea(
            child:
            Column(
              children: [
                SizedBox(height: 10),
                //간격
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
                    color: Color(0xFF609966), // #609966 색상 지정
                  ),
                ),
                SizedBox(height: 10), //간격
                ////////////////////////////////////////////////////////////

                Container(
                  width: 350,
                  height: 470,
                  child: RepaintBoundary(
                    key: globalKey,
                    child: Stack(
                      children: [
                        Visibility(
                            visible: !isFrontImageVisible,
                            child: Image.file(
                              File(widget.backImagePath),
                              width: 350,
                              height: 470,
                            )
                          ),
                          ...backImageStickers.map(
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
                            visible: isFrontImageVisible,
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi),
                              child: Image.file(
                                File(widget.frontImagePath),
                                width: 350,
                                height: 470,
                              ),
                            ),
                          ),
                          ...frontImageStickers.map(
                                (sticker) =>
                                Center(
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
                SizedBox(height: 10), //간격

                ////////////////////////////////////////////////////////////
                /* ↓↓↓↓↓ 텍스트, 플립, 스티커 버튼 ↓↓↓↓↓ */

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //텍스트 버튼
                    InkWell(
                      onTap: () {

                      },
                      child: Image.asset(
                          "button/text.png",
                          width: 30,
                          height: 30
                      ),
                    ),
                    SizedBox(width: 50),
                    //사진 전환 버튼
                    InkWell(
                      onTap: () async {
                        if (!isFrontImageVisible) { //후면->전면은 가능하지만 전면에서 다시 후면으로 넘어가서 꾸밀 수 없음
                          setState(() {
                            isFrontImageVisible = !isFrontImageVisible;
                            isSendingButtonEnabled = true;
                          });


                          RenderRepaintBoundary boundary = globalKey.currentContext!
                              .findRenderObject() as RenderRepaintBoundary;
                          ui.Image image = await boundary.toImage();
                          ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

                          if (byteData != null) {
                            Uint8List pngBytes = byteData.buffer.asUint8List();
                            final_backImagePath = pngBytes; // 이미지 데이터를 frontImagePath에 저장
                          }
                        }
                      },

                      child: isFrontImageVisible
                          ? Image.asset(
                        "button/flip_disabled.png", // 비활성화된 버튼 이미지
                        width: 30,
                        height: 30,
                      )
                          : Image.asset(
                        "button/flip.png", // 활성화된 버튼 이미지
                        width: 30,
                        height: 30,
                      ),
                    ),
                    SizedBox(width: 50), //간격

                    // 스티커 버튼
                    InkWell(
                      onTap: () {
                        _showStickerPicker(context);
                      },
                      child: Image.asset(
                          "button/sticker.png",
                          width: 30,
                          height: 30
                      ),
                    ),
                    SizedBox(width: 50),
                    IconButton(
                      onPressed: () {
                        UndoSticker();
                      },
                      icon: Icon(
                        Icons.undo,
                        color: Color(0xFF609966),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10), //간격

                //////////////////////////////////////////////////////////
                /* ↓↓↓↓↓ 상태 전송 버튼 ↓↓↓↓↓ */
                ElevatedButton(
                  onPressed: isSendingButtonEnabled
                      ? () async {
                    RenderRepaintBoundary boundary = globalKey.currentContext!
                        .findRenderObject() as RenderRepaintBoundary;
                    ui.Image image = await boundary.toImage();
                    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                    if (byteData != null) {
                      Uint8List pngBytes = byteData.buffer.asUint8List();
                      final_frontImagePath = pngBytes; // 이미지 데이터를 frontImagePath에 저장
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TScreen(
                            backImagePath: final_backImagePath,
                            frontImagePath: final_frontImagePath,
                          )),
                    );
                  }
                    : null,
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15), // 내부 여백 설정
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // 둥근 모서리 설정
                      ),
                      fixedSize: Size(180, 55),
                      backgroundColor: Color(0xff609966)
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // 아이콘과 텍스트를 가로로 배치
                    children: [
                      Image.asset(
                          "button/send_white.png",
                          height: 20,
                          width: 20
                      ),
                      SizedBox(width: 20), // 아이콘과 텍스트 사이 간격
                      Text(
                        '상태 전송',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ), // 텍스트 추가
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onStickerTap(int index) async {
    setState(() {
      if (isFrontImageVisible) { //셀카이면
        frontImageStickers.add(
          StickerModel(
            id: Uuid().v4(),
            imgPath: 'assets/emoticons/emoticon_$index.png',
          ),
        );
      } else { //후면카메라이면
        backImageStickers.add(
          StickerModel(
            id: Uuid().v4(),
            imgPath: 'assets/emoticons/emoticon_$index.png',
          ),
        );
      }
    });
  }

  void _showStickerPicker(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            AlertDialog(
              backgroundColor: Colors.transparent,
              content: StickerPicker(onStickerTap: onStickerTap),
              actions: [
                IconButton( // close 버튼 누르면 스티커 팝업 닫기
                  icon: Icon(Icons.close),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop(); // AlertDialog 닫기
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void onTransform(String id) {
    setState(() {
      selectedId = id;
    });
  }


  void UndoSticker() async {
    if (!isFrontImageVisible && backImageStickers.isNotEmpty) {
      setState(() {
        StickerModel lastStickerback = backImageStickers.last;
        backImageStickers.remove(lastStickerback);
        backImageStickers.removeWhere((sticker) => sticker.id == lastStickerback.id);
      });
    }
    else if (isFrontImageVisible && frontImageStickers.isNotEmpty) {
      setState(() {
        StickerModel lastStickerfront = frontImageStickers.last;
        frontImageStickers.remove(lastStickerfront);
        frontImageStickers.removeWhere((sticker) => sticker.id == lastStickerfront.id);
      });
    }
  }
}
