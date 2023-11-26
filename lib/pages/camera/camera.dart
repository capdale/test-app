import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;
import 'package:modak/modak.dart';
import 'package:provider/provider.dart';
import 'package:test_app/pages/geolocation/geolocation.dart';
import 'package:test_app/provider/modak_provider.dart';

class CameraPage extends StatefulWidget {
  CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  bool _isCameraReady = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    availableCameras().then((cameras) {
      if (cameras.isNotEmpty && _cameraController == null) {
        _cameraController = CameraController(
            cameras.first, ResolutionPreset.max,
            imageFormatGroup: ImageFormatGroup.jpeg, enableAudio: false);
        _cameraController!.initialize().then((value) {
          if (!mounted) {
            return;
          }
          setState(() {
            _isCameraReady = true;
          });
        }).catchError((Object e) {
          if (e is CameraException) {
            switch (e.code) {
              case 'CameraAccessDenied':
                break;
              default:
                break;
            }
          }
        });
      }
    }).catchError((e) {});
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
    if (_cameraController == null) return Container();
    if (!_cameraController!.value.isInitialized) return Container();
    final cameraWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: OverflowBox(
        maxHeight: cameraWidth,
        child: SizedBox(
          width: cameraWidth,
          height: cameraWidth * _cameraController!.value.aspectRatio,
          child: CameraPreview(_cameraController!),
        ),
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.camera),
        onPressed: () => _onTakePhoto(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class PhotoPreview extends StatelessWidget {
  final String imagePath;
  const PhotoPreview({required this.imagePath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: isGeoLocationServiceEnable(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            if (snapshot.hasError) {
              Navigator.pop(context);
            }
            if (snapshot.data == false) {
              return const Center(
                child: Text("has no permission"),
              );
            }
            return Center(
              child: Image.file(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  File(imagePath),
                  fit: BoxFit.fill),
            );
          }),
      floatingActionButton: IconButton(
          onPressed: () async {
            final modak = context.read<ModakChangeNotifier>().modak!;

            img.Image? image =
                img.decodeImage(File(imagePath).readAsBytesSync());
            if (image == null) {
              const snackBar = SnackBar(content: Text("Error"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return;
            }
            final position = await Geolocator.getCurrentPosition();
            final resizedImage =
                img.copyResize(image, width: 1080, height: 1080);
            final isSuccess = await modak.collection
                .postCollection(img.encodeJpg(resizedImage), position.accuracy,
                    position.accuracy, position.accuracy, position.accuracy)
                .then((value) {
              if (value) {
                const snackBar = SnackBar(content: Text("Success"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return;
              }
              const snackBar = SnackBar(content: Text("Server Error"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
          },
          icon: const Icon(Icons.check)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

Future<bool> isGeoLocationServiceEnable() async {
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return false;
  }
  if (permission == LocationPermission.deniedForever) {
    return false;
  }
  return true;
}
