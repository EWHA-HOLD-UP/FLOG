import 'package:camera/camera.dart';
import 'package:flog/screen/shooting_preview_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Shooting_screen extends StatefulWidget {
  const Shooting_screen({Key? key}) : super(key: key);

  State<Shooting_screen> createState() => _ShootingScreenState();
}

class _ShootingScreenState extends State<Shooting_screen> {
  CameraController? _cameraController;
  bool _isCameraReady = false;
  String? _tempBackImagePath; // 임시 후면 사진 저장
  String? _tempFrontImagePath; // 임시 전면 사진 저장

  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      if (cameras.isNotEmpty && _cameraController == null) {
        _initializeCameraController(cameras.first);
      }
    });
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

  void _onTakeBackPicture(BuildContext context) {
    if(_cameraController == null || !_isCameraReady) return;
    
    _cameraController!.takePicture().then((image) {
      setState(() {
        _tempBackImagePath = image.path;
      });

      Timer(Duration(seconds: 2), () {
        availableCameras().then((cameras) {
          for (CameraDescription camera in cameras) {
            if (camera.lensDirection == CameraLensDirection.front) {
              _initializeCameraController(camera);
              _cameraController!.takePicture().then((image) {
                setState(() {
                  _tempFrontImagePath = image.path;
                });
                _navigateToPreviewScreen();
              });
              break;
            }
          }
        });
      });
    });
  }

  void _navigateToPreviewScreen() {
    if (_tempBackImagePath != null && _tempFrontImagePath != null) {
      Navigator.of(context as BuildContext).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ShootingPreviewScreen(
            backImagePath: _tempBackImagePath!,
            frontImagePath: _tempFrontImagePath!,
          ),
        ),
      );
    }
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
               onPressed: _cameraController != null && _isCameraReady
                   ? () {
                 _onTakeBackPicture(context);
               }
               : null,
               child: const Text('찰칵'),
               style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
             ),
            ],
          ),
        ),
      );
  }
}
