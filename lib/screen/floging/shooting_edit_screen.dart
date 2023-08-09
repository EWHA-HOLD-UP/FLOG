import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flog/widgets/ImageSticker/shooting_edit_footer.dart';
import 'package:flog/widgets/TextSticker/text_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'dart:ui' as ui;
import '../../widgets/ImageSticker/emoticon_sticker.dart';
import '../../widgets/ImageSticker/sticker_model.dart';

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

  bool isFrontImageVisible = false; //플립 기능 위한 부분

  Set<StickerModel> frontImageStickers = {}; //셀카 스티커
  Set<StickerModel> backImageStickers = {}; //후면 카메라 스티커
  String? selectedId;
  GlobalKey imgKey = GlobalKey();
  GlobalKey imgKey2 = GlobalKey();
  String? _editiedFrontImagePath = '';
  String? _editiedBackImagePath = '';


  @override
  Widget build(BuildContext context) {
    return WillPopScope( //뒤로가기 해서 사진 다시 찍는 것 막음
      onWillPop: () async => false,
      child:
        Scaffold(
          body: Center(
            child : SafeArea(
              child: Stack(
                children: [
                  Column(
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
                        ////////////////////////////////////////////////////////////
                        /* ↓↓↓↓↓ 사진 보여주기 ↓↓↓↓↓ */
                        Container(
                          width: 350,
                          height: 470,
                          child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  RepaintBoundary(
                                    key: imgKey,
                                    child:
                                      InteractiveViewer( //확대축소
                                        child:
                                          Stack(
                                            children: [
                                              Visibility(
                                                visible: !isFrontImageVisible, //후면 사진
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
                                  ),
                                  RepaintBoundary(
                                    key: imgKey2,
                                    child:
                                      InteractiveViewer( //확대축소
                                        child:
                                          Stack(
                                            children: [
                                              Visibility(
                                                visible: isFrontImageVisible, //전면 사진
                                                child: Transform( //좌우 반전
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
                                  ),
                                ],
                              ),
                            ),

                        SizedBox(height:10), //간격

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
                                  if(isFrontImageVisible) { // 셀카이면
                                    RenderRepaintBoundary boundary = imgKey2
                                        .currentContext!
                                        .findRenderObject() as RenderRepaintBoundary;
                                    ui.Image image = await boundary.toImage();
                                    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                                    Uint8List pngBytes = byteData!.buffer.asUint8List();
                                    String editedImagePath = await _saveEditedImage(pngBytes);
                                    setState(() {
                                      _editiedFrontImagePath = editedImagePath;

                                    });
                                  } else { //후면카메라이면
                                    RenderRepaintBoundary boundary = imgKey
                                        .currentContext!
                                        .findRenderObject() as RenderRepaintBoundary;
                                    ui.Image image = await boundary.toImage();
                                    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                                    Uint8List pngBytes = byteData!.buffer.asUint8List();
                                    String editedImagePath = await _saveEditedImage(pngBytes);
                                    setState(() {
                                      _editiedBackImagePath = editedImagePath;
                                      isFrontImageVisible = !isFrontImageVisible; //사진 전환
                                    });
                                  };
                                },
                              child: Image.asset(
                                  "button/flip.png",
                                  width: 30,
                                  height: 30
                                ),
                            ),

                            SizedBox(width: 50), //간격

                            //스티커 버튼
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
                              onPressed: onDeleteItem,
                              icon: Icon(
                                  Icons.delete_forever,
                                  color: Colors.green,
                                ),
                            )
                          ],
                        ),

                        SizedBox(height:10), //간격

                        ////////////////////////////////////////////////////////////
                        /* ↓↓↓↓↓ 상태 전송 버튼 ↓↓↓↓↓ */
                        ElevatedButton(
                          onPressed: isFrontImageVisible ? () {
                            } : null,
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
                ],
              ),
            ),
          ),
        ),
    );
  }


  void onTransform(String id) {
    setState(() {
      selectedId = id;
    });
  }

  //스티커 삭제
  void onDeleteItem() async {
    setState(() {
      if (isFrontImageVisible) { //셀카이면
        frontImageStickers = frontImageStickers
            .where((sticker) => sticker.id != selectedId)
            .toSet();
      } else { //후면카메라이면
        backImageStickers = backImageStickers
            .where((sticker) => sticker.id != selectedId)
            .toSet();

      }
      selectedId = null;
    });
  }

  //각 카메라마다 붙인 스티커 저장
  void onEmoticonTap(int index) async {
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

  //스티커 보여주기
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

  Future<String> _saveEditedImage(Uint8List imageBytes) async {
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/edited_image.png';

    final editedImageFile = File(imagePath);
    await editedImageFile.writeAsBytes(imageBytes);

    return imagePath;
  }



}