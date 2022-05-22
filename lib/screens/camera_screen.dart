import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

enum ScreenMode { liveFeed, gallery }

class CameraView extends StatefulWidget {
  const CameraView(
      {Key? key,
      required this.title,
      required this.customPaint,
      required this.onImage,
      this.initialDirection = CameraLensDirection.back})
      : super(key: key);

  final String title;
  final CustomPaint? customPaint;
  final Function(InputImage inputImage) onImage;
  final CameraLensDirection initialDirection;

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  PoseDetector poseDetector = GoogleMlKit.vision.poseDetector();
  CameraController? _controller;

  late int _counter = 0;
  late bool check = false;
  late bool checkNext = true;

  @override
  void initState() {
    super.initState();
    _startCamera();
  }

  @override
  void dispose() {
    _stopCamera();
    super.dispose();
  }

  void incrementCounter() {
    setState(() {
      _counter++;
    });

    check = false;
    checkNext = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    Widget body;
    body = _liveFeedBody();
    return body;
  }

  Widget _liveFeedBody() {
    if (_controller?.value.isInitialized == false) {
      return Container();
    }

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(_controller!),
          if (widget.customPaint != null) widget.customPaint!,
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('$_counter', style: const TextStyle(
                  color: Colors.red,
                  fontSize: 40,
                ),),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future _startCamera() async {
    final camera = cameras[1];
    
    _controller = CameraController(
      camera,
      ResolutionPreset.low,
      enableAudio: false,
    );

    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }

      _controller?.startImageStream(_processCameraImage);
      
      setState(() {});
    });
  }

  Future _stopCamera() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[1];
    final imageRotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation) ?? InputImageRotation.rotation0deg;

    final inputImageFormat = InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    counterPose(inputImage);

    widget.onImage(inputImage);
  }

  Future? counterPose(inputImage) async {

    final List<Pose> poses = await poseDetector.processImage(inputImage);

    for (Pose pose in poses){
      // Desni kuk
      final rightHip = pose.landmarks[PoseLandmarkType.rightHip]!.y;
      // Desno koljeno
      final rightKnee = pose.landmarks[PoseLandmarkType.rightKnee]!.y;

      print(rightHip);
      print(rightKnee);

      print('checkNext');
      print(checkNext);

      print('check');
      print(check);

      print('counter');
      print(_counter);

      // Ako je true, treba povecati za 1
      if( check == true && checkNext == true ){
        print('napravljeno');
        incrementCounter();
      }

      if( rightHip > rightKnee ){
        checkNext = false;
        check = false;
      } else {
        checkNext = true;
        check = true;
      }
    }
  }

}