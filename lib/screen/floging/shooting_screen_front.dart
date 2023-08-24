import 'package:camera/camera.dart';
import 'package:flog/screen/floging/shooting_edit_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

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
  }

  //카메라 컨트롤러 initalize
  void _initializeCameraController(CameraDescription camera) {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    _cameraController!.initialize().then((_) {
      setState(() {
        _isCameraReady = true; //카메라 컨트롤러 initalize 마쳤을 때
      });
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
  void _takeFrontPicture(BuildContext context) {
    if(_cameraController == null || !_isCameraReady) return;
    _cameraController!.takePicture().then((image) {
      setState(() {
        _tempFrontImagePath = image.path;
      });
      _navigateToEditScreen(context); //Edit Screen으로 전환
    });
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
      child: Scaffold(
        body: Center(
          child : SafeArea(
            child: Column(
              children: [
                const SizedBox(height:10), //간격
                Row(
                  children: [
                    const SizedBox(width: 20), //간격
                    InkWell( //close 아이콘 버튼
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        },
                      child: Image.asset(
                          "button/close.png",
                          width: 20,
                          height: 20
                      ),
                    ),
                    const SizedBox(width: 135), //간격
                    Image.asset(
                      "assets/flog_logo.png",
                      width: 55,
                      height: 55,
                    ),
                  ],
                ),
                const Text(
                  "FLOGing",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF609966), // #609966 색상 지정
                  ),
                ),
                const SizedBox(height:10), // 간격
                SizedBox( //카메라 프리뷰 크기 조절
                  width: 350,
                  height: 470,
                  child: _cameraController != null && _isCameraReady
                      ? CameraPreview(_cameraController!)
                      :Container(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height:10), //간격
                Text(guide), //ai 가이드 문구
                const SizedBox(height:10), //간격
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                      child: Image.asset(
                        "button/flash.png",
                        width: 50,
                        height: 50,
                        color: _isFlashOn ? null : Colors.grey, // 플래시 상태에 따라 아이콘 색상 변경
                      ),
                    ),
                    const SizedBox(width: 35),
                    InkWell( //전면 카메라 촬영 버튼
                      onTap:
                      _cameraController != null && _isCameraReady
                          ? () {
                        _takeFrontPicture(context);
                      }
                      : null,
                      child: Image.asset(
                          "button/shooting.png",
                          width: 60,
                          height: 60
                      ),
                    ),
                    const SizedBox(width: 35), //간격
                    InkWell( //앞뒤 전환 아이콘 버튼
                      onTap: () {
                        //구현 or 삭제 필요
                        },
                      child: Image.asset(
                          "button/flip.png",
                          width: 40,
                          height: 40
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
}

