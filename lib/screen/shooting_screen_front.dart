import 'package:camera/camera.dart';
import 'package:flog/screen/shooting_preview_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flog/screen/setting_screen.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Shooting_screen_front extends StatefulWidget {
  final String backImagePath;
  const Shooting_screen_front({Key? key, required this.backImagePath}) : super(key: key);
  State<Shooting_screen_front> createState() => _ShootingScreenFrontState();
}

class _ShootingScreenFrontState extends State<Shooting_screen_front> {
  CameraController? _cameraController;
  bool _isCameraReady = false;
  String? _tempFrontImagePath; // 임시 전면 사진 저장


  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    for(CameraDescription camera in cameras) {
      if(camera.lensDirection == CameraLensDirection.front) {
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

  void _navigateToPreviewScreen(BuildContext context) {
    if (_tempFrontImagePath != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ShootingPreviewScreen(
            backImagePath: widget.backImagePath,
            frontImagePath: _tempFrontImagePath!,
          ),
        ),
      );
    }
  }



  void _takeFrontPicture(BuildContext context) {

    if(_cameraController == null || !_isCameraReady) return;
    _cameraController!.takePicture().then((image) {
      setState(() {
        _tempFrontImagePath = image.path;
      });
      _navigateToPreviewScreen(context);
    });
  }

  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('카메라로 찍으세요'),
          backgroundColor: Colors.green
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: _cameraController != null && _isCameraReady
                  ? CameraPreview(_cameraController!)
                  : Container(
                color: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed:
              _cameraController != null && _isCameraReady
                  ? () {
                _takeFrontPicture(context);
              }
                  : null,
              child: const Text('전면'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
