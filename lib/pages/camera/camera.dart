import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TakePhotoPage()));
          },
          child: const Text("Camera")),
    );
  }
}

class TakePhotoPage extends StatefulWidget {
  TakePhotoPage({Key? key}) : super(key: key);

  @override
  State<TakePhotoPage> createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  CameraController? _cameraController;
  bool _isCameraReady = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    availableCameras().then((cameras) {
      if (cameras.isNotEmpty && _cameraController == null) {
        _cameraController =
            CameraController(cameras.first, ResolutionPreset.max);
        _cameraController!.initialize().then((value) {
          setState(() {
            _isCameraReady = true;
          });
        }).catchError((Object e) {
          if (e is CameraException) {
            switch (e.code) {
              case 'CameraAccessDenied':
                print("CameraAccessDenied");
                break;
              default:
                print("default error");
                break;
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    if (_cameraController != null) _cameraController!.dispose();
    super.dispose();
  }

  void _onTakePhoto(BuildContext context) {
    _cameraController!.takePicture().then((image) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PhotoPreview(imagePath: image.path)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: _cameraController != null && _isCameraReady
                ? CameraPreview(_cameraController!)
                : Container(),
          ),
          IconButton(
              onPressed: _isCameraReady ? () => _onTakePhoto(context) : null,
              icon: const Icon(Icons.camera))
        ],
      ),
    );
  }
}

class PhotoPreview extends StatelessWidget {
  final String imagePath;
  const PhotoPreview({required this.imagePath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.file(File(imagePath)),
    );
  }
}
