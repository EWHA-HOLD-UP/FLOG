import 'package:camera/camera.dart';
import 'package:flog/screen/shooting_preview_screen.dart';
import 'package:flutter/material.dart';

class Shooting_screen extends StatefulWidget {
  const Shooting_screen({super.key});

  State<Shooting_screen> createState() => _Shooting_screenState();
}

class _Shooting_screenState extends State<Shooting_screen> {
  CameraController? _cameraController;
  bool _isCameraReady = false;

  void initState(){
    super.initState();
    availableCameras().then((cameras) {
      if(cameras.isNotEmpty && _cameraController == null) {
        _cameraController = CameraController(
          cameras.first,
          ResolutionPreset.medium,
        );

        _cameraController!.initialize().then((_) {
          setState(() {
            _isCameraReady = true;
          });
        });
      }
    });
  }

  void _onTakePicture(BuildContext context) {
    _cameraController!.takePicture().then((image) {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => PhotoPreview(
              imagePath: image.path,
            ),
        ),
      );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('후면 카메라로 찍으세요'),
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
            Center(
              child: ElevatedButton(
                onPressed: _cameraController != null
                ? () => _onTakePicture(context)
                : null, child: const Text('촬영'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
