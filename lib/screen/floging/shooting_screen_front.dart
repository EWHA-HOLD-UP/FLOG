import 'package:camera/camera.dart';
import 'package:flog/screen/floging/shooting_edit_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

class ShootingScreenFront extends StatefulWidget {
  final String backImagePath;
  const ShootingScreenFront({Key? key, required this.backImagePath}) : super(key: key);

  @override
  State<ShootingScreenFront> createState() => _ShootingScreenFrontState();
}

class _ShootingScreenFrontState extends State<ShootingScreenFront> {
  CameraController? _cameraController; //카메라 컨트롤러
  bool _isCameraReady = false;
  String? _tempFrontImagePath; //임시 전면 사진 저장
  String guide = '가족들의 하루를 응원하는 마음을 담아 화이팅! 을 표현해주세요.'; //ai가 생성한 가이드 문구
  bool _isCameraInitialized = false; //카메라 초기화되었는지
  bool _isProcessing = false; //사진 찍히고 있는지
  bool _isFlashOn = true; //플래시 켜져있는지

  //카메라 초기화
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  //전면 카메라 - 가능한 카메라들의 목록을 하나 하나 검사하면서 전면 카메라를 발견하면 탐색 멈춤
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    for(CameraDescription camera in cameras) {
      if(camera.lensDirection == CameraLensDirection.front) {
        _initializeCameraController(camera);
        break;
      }
    }
    setState(() {
      _isCameraInitialized = true; // 카메라 초기화 완료
    });
  }

  //카메라 컨트롤러 initalize
  void _initializeCameraController(CameraDescription camera) {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    _cameraController!.initialize().then((_) {
      if (mounted) {
        setState(() {
          _isCameraReady = true; //카메라 컨트롤러 initalize 마쳤을 때
        });
      }
    });
  }

  //Edit Screen으로 전환하는 함수
  void _navigateToEditScreen(BuildContext context) {
    if (_tempFrontImagePath != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ShootingEditScreen(
            backImagePath: widget.backImagePath,
            frontImagePath: _tempFrontImagePath!,
          ),
        ),
      );
    }
  }

  //전면 카메라 촬영
  void _takeFrontPicture(BuildContext context) async {
    if(_cameraController == null || !_isCameraReady || _isProcessing) return;
    setState(() {
      _isProcessing = true; // 사진 처리 중 표시
    });
    try {
      final image = await _cameraController!.takePicture();
      setState(() {
        _tempFrontImagePath = image.path;
        _isProcessing = false;
      });
      _navigateToEditScreen(context);
    } catch (e) {
      setState(() {
        _isProcessing = false; // 사진 처리 실패 시 처리 중 표시 해제
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope( //뒤로가기 막음
      onWillPop: () async => false,
      child: Expanded(
        child: Scaffold(
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
          /*---화면---*/
          backgroundColor: Colors.white, //화면 배경색
          body: Center(
            child : SafeArea(
              child: Column(
                children: [
                  const SizedBox(height:10), // 간격
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20), //둥근 모서리
                        child: SizedBox(
                          width: 360,
                          height: 520,
                          child: _cameraController != null && _isCameraReady
                              ? CameraPreview(_cameraController!)
                              : Container(
                            color: Colors.white,
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
                                    style: TextStyle(
                                      color: Color(0xFF609966),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Text(
                                    '메인으로 돌아가면 방금 찍은 사진은 복구할 수 없어요!\n신중히 고민하신 후에 \'확인\'을 눌러주세요.',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13
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
                                            Navigator.of(context).pop();
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
                  ),
                  const SizedBox(height:10), //간격
                  Text(guide), //ai 가이드 문구
                  const SizedBox(height:10), //간격
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 85),
                      InkWell( //전면 카메라 촬영 버튼
                        onTap:
                        _cameraController != null && _isCameraReady
                            ? () {
                          _takeFrontPicture(context);
                        }
                            : null,
                        child: _isProcessing
                            ? const CircularProgressIndicator(
                          color: Color(0xFF609966),
                        ) // 사진 처리 중에는 로딩 스피너 표시
                            : Image.asset(
                          "button/shooting.png",
                          width: 60,
                          height: 60,
                          color: _cameraController != null && _isCameraReady && _isCameraInitialized
                              ? null
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 35), //간격
                      InkWell( //플래시 아이콘 버튼
                        onTap: () {
                          setState(() {
                            _isFlashOn = !_isFlashOn; // 플래시 상태를 토글
                            if (_isFlashOn) {
                              _cameraController?.setFlashMode(FlashMode.auto);
                            } else {
                              _cameraController?.setFlashMode(FlashMode.off);
                            }
                          });
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "button/flash.png",
                              width: 50,
                              height: 50,
                              color: _isFlashOn ? null : Colors.grey, // 플래시 상태에 따라 아이콘 색상 변경
                            ),
                            Text(
                              _isFlashOn ? "auto" : "off", // 텍스트 내용
                              style: TextStyle(
                                color: _isFlashOn ? Color(0xFF609966) : Colors.grey, // 텍스트 색상 변경
                              ),
                            ),
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
      )
    );
  }
}

