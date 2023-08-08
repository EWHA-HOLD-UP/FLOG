import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flog/screen/root_screen.dart';
import 'package:flog/screen/floging/shooting_screen_back.dart';
import 'package:flog/widgets/shooting_edit_footer.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import '../../widgets/emoticon_sticker.dart';
import '../../widgets/sticker_model.dart';
import '../../widgets/sticker_app_bar.dart';

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

  //플립 기능 위한 부분
  bool isFrontImageVisible = true;

  Set<StickerModel> frontImageStickers = {};
  Set<StickerModel> backImageStickers = {};
  String? selectedId;


  @override
  Widget build(BuildContext context) {
    return WillPopScope( //뒤로가기 해서 사진 다시 찍는 것 막음
      onWillPop: () async => false,
      child:
        Scaffold(
          body: Center(
            child : SafeArea(
              child: Column(
                  children: [
                    SizedBox(height:10), //간격
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
                    SizedBox(height:10), //간격
                    /////////////////////
                    Container(
                      width: 350,
                      height: 470,
                      child: Stack(
                            alignment: Alignment.center,
                            children: [
                              InteractiveViewer(
                                child:
                                  Stack(
                                    children: [
                                      Visibility(
                                        visible: !isFrontImageVisible,
                                        child: Image.file(
                                          File(widget.backImagePath),
                                          width: 350,
                                          height: 470,
                                        ),
                                      ),
                                      ...backImageStickers.map(
                                            (sticker) => Center(
                                          child: EmoticonSticker(
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
                              InteractiveViewer(
                                child:
                                  Stack(
                                    children: [
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
                                            (sticker) => Center(
                                          child: EmoticonSticker(
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
                            ],
                          ),
                        ),
                    SizedBox(height:10), //간격
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell( //글자 추가 버튼
                          onTap: () {

                          },
                          child: Image.asset(
                              "button/text.png",
                              width: 30,
                              height: 30
                          ),
                        ),
                        SizedBox(width: 70),
                        InkWell( //사진 전환 버튼
                          onTap: () {
                            setState(() {
                              isFrontImageVisible = !isFrontImageVisible;
                              if (isFrontImageVisible) {
                                frontImageStickers.clear();
                              } else {
                                backImageStickers.clear();
                              }
                            });
                            },
                          child: Image.asset(
                              "button/flip.png",
                              width: 30,
                              height: 30
                            ),
                        ),
                        SizedBox(width: 70), //간격
                        InkWell( //스티커 아이콘 버튼
                            onTap: () {
                              _showStickerPicker(context);

                            },
                            child: Image.asset(
                                "button/sticker.png",
                                width: 30,
                                height: 30
                            ),
                        ),
                      ],
                    ),
                    SizedBox(height:15), //간격
                    ElevatedButton(
                      onPressed: () {
                  
                        }, 
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),  // 내부 여백 설정
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),  // 둥근 모서리 설정
                        ),
                        fixedSize: Size(180, 55),
                        backgroundColor: Color(0xff609966)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,  // 아이콘과 텍스트를 가로로 배치
                        children: [
                          Image.asset(
                              "button/send_white.png",
                              height: 20,
                              width: 20
                          ),
                          SizedBox(width: 20),  // 아이콘과 텍스트 사이 간격
                          Text(
                            '상태 전송',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              )
                          ),  // 텍스트 추가
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

  void onEmoticonTap(int index) async {
    setState(() {
      if (isFrontImageVisible) {
        frontImageStickers.add(
          StickerModel(
            id: Uuid().v4(),
            imgPath: 'assets/emoticons/emoticon_$index.png',
          ),
        );
      } else {
        backImageStickers.add(
          StickerModel(
            id: Uuid().v4(),
            imgPath: 'assets/emoticons/emoticon_$index.png',
          ),
        );
      }
    });
  }

  void onTransform(String id) {
    setState(() {
      selectedId = id;
    });
  }

  void onDeleteItem() async {
    setState(() {
      if (isFrontImageVisible) {
        frontImageStickers = frontImageStickers
            .where((sticker) => sticker.id != selectedId)
            .toSet();
      } else {
        backImageStickers = backImageStickers
            .where((sticker) => sticker.id != selectedId)
            .toSet();
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
              content: Footer(onEmoticonTap: onEmoticonTap),
              actions: [
                IconButton(
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
}