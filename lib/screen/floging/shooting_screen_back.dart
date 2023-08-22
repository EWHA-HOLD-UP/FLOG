import 'package:camera/camera.dart';
import 'package:flog/screen/floging/shooting_screen_front.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ShootingScreen extends StatefulWidget {
  final String? backImagePath;

  const ShootingScreen({Key? key, this.backImagePath}) : super(key: key);

  @override
  State<ShootingScreen> createState() => _ShootingScreenState();
}

class _ShootingScreenState extends State<ShootingScreen> {
  CameraController? _cameraController; //카메라 컨트롤러
  bool _isCameraReady = false;
  String? _tempBackImagePath; //임시 후면 사진 저장
  String guide = '가족들의 하루를 응원하는 마음을 담아 화이팅! 을 표현해주세요.'; //ai가 생성한 가이드 문구
  bool _isCameraInitialized = false;
  bool _isProcessing = false;

  //카메라 초기화
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  //후면 카메라 - 가능한 카메라들 목록을 하나하나 검사하면서 후면 카메라를 발견하면 탐색 멈춤
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    for(CameraDescription camera in cameras) {
      if(camera.lensDirection == CameraLensDirection.back) {
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

  //전면 카메라 화면으로 전환하는 함수
  void _navigateToFrontScreen(BuildContext context) {
    if (_tempBackImagePath != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ShootingScreenFront(
            backImagePath: _tempBackImagePath!,
          ),
        ),
      );
    }
  }

  //후면 카메라 촬영
  Future<void> _takeBackPicture(BuildContext context) async {
    if (_cameraController == null || !_isCameraReady || _isProcessing) return;
    setState(() {
      _isProcessing = true; // 사진 처리 중 표시
    });

    try {
      final image = await _cameraController!.takePicture();
      setState(() {
        _tempBackImagePath = image.path;
        _isProcessing = false; // 사진 처리 완료
      });
      _navigateToFrontScreen(context);
    } catch (e) {
      setState(() {
        _isProcessing = false; // 사진 처리 실패 시 처리 중 표시 해제
      });
      // 에러 처리
    }
  }

  @override
  void dispose() {
      _cameraController?.dispose();
      super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child :
          Scaffold(
            body: Center(
              child : SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height:10), //간격
                      Row(
                        children: [
                          SizedBox(width: 20), //간격
                          InkWell( //close 아이콘 버튼
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                                "button/close.png",
                                width: 20,
                                height: 20
                            ),
                          ),
                          SizedBox(width: 135), //간격
                          Image.asset(
                            "assets/flog_logo.png",
                            width: 55,
                            height: 55,
                          ),
                        ],
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
                      Container( //카메라 프리뷰 크기 조절
                        width: 350,
                        height: 470,
                        child: _cameraController != null && _isCameraReady
                            ? CameraPreview(_cameraController!)
                            :Container(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height:10), //간격
                      Text('$guide'), //ai 가이드 문구
                      SizedBox(height:10), //간격
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell( //플래시 아이콘 버튼
                              onTap: () {

                              },
                            child: Image.asset(
                                "button/flash.png",
                                width: 50,
                                height: 50
                            ),
                          ),
                          SizedBox(width: 35), //간격
                          InkWell( //후면 카메라 촬영 버튼
                            onTap:
                            _cameraController != null && _isCameraReady
                                ? () {
                              _takeBackPicture(context);
                            }
                            : null,

                            child: _isProcessing
                                ? CircularProgressIndicator(
                                color: Color(0xFF609966),
                            ) // 사진 처리 중에는 로딩 스피너 표시
                                : Image.asset(
                              "button/shooting.png",
                              width: 60,
                              height: 60,
                              color: _cameraController != null && _isCameraReady
                                  ? null
                                  : Colors.grey,
                            ),
                          ),
                          SizedBox(width: 35), //간격
                          InkWell( //앞뒤 전환 아이콘 버튼
                            onTap: () {

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
