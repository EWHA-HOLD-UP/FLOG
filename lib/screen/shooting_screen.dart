import 'package:camera/camera.dart';
import 'package:flog/screen/shooting_preview_screen.dart';
import 'package:flog/screen/shooting_screen_front.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Shooting_screen extends StatefulWidget {
  final String? backImagePath;
  const Shooting_screen({Key? key, this.backImagePath}) : super(key: key);
  State<Shooting_screen> createState() => _ShootingScreenState();
}

class _ShootingScreenState extends State<Shooting_screen> {
  CameraController? _cameraController;
  bool _isCameraReady = false;
  String? _tempBackImagePath; // 임시 후면 사진 저장


  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    for(CameraDescription camera in cameras) {
      if(camera.lensDirection == CameraLensDirection.back) {
        _initializeCameraController(camera);
        break;
          }
        }
      }

  void _initializeCameraController(CameraDescription camera) {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    _cameraController!.initialize().then((_) {
      setState(() {
        _isCameraReady = true;
      });
    });
  }

  void _navigateToFrontScreen(BuildContext context) {
    if (_tempBackImagePath != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Shooting_screen_front(
            backImagePath: _tempBackImagePath!,
          ),
        ),
      );
    }
  }



  void _onTakeBackPicture(BuildContext context) {
    if (_cameraController == null || !_isCameraReady) return;
    _cameraController!.takePicture().then((image) {
      setState(() {
        _tempBackImagePath = image.path;
      });
      _navigateToFrontScreen(context);
    });
  }



  void dispose() {
      _cameraController?.dispose();
      super.dispose();
  }

  Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
          child : SafeArea(
              child: Column(
                children: [
                  SizedBox(height:30),
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
                  SizedBox(height:20), // 간격

                  Container(
                    width: 350,
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0), // 모서리 둥글기 조절
                    ),
                    child: _cameraController != null && _isCameraReady
                        ? CameraPreview(_cameraController!)
                        :Container(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height:20),
                  Text('가족들의 하루를 응원하는 마음을 담아 화이팅! 을 표현해주세요.'),
                  SizedBox(height:20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(50, 50),
                            shape: const CircleBorder(),
                            shadowColor: Colors.white,
                            backgroundColor: Color(0xE1EBE1),
                          ),
                          child: Icon(Icons.flash_on),
                      ),
                      SizedBox(width: 35),
                      ElevatedButton(
                        onPressed:
                        _cameraController != null && _isCameraReady
                            ? () {
                          _onTakeBackPicture(context);
                        }
                        : null,
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(60, 60),
                            shape: const CircleBorder(),
                            shadowColor: Colors.white,
                            backgroundColor: Color(0xFF609966),
                        ),
                        child: null,
                      ),
                      SizedBox(width: 35),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(50, 50),
                          shape: const CircleBorder(),
                          shadowColor: Colors.white,
                          backgroundColor: Color(0xE1EBE1),
                        ),
                        child: Icon(Icons.change_circle_outlined),
                      ),
                    ],
                  ),
                ],
              ),
          ),
        ),
      );
  }
}
