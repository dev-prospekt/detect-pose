import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'PoseDetectionPage.dart';

class StartPage extends StatefulWidget {
  final List<CameraDescription>? cameras;

  const StartPage({this.cameras, Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late CameraController controller;

  final int _counter = 0;

  @override
  Widget build(BuildContext context) {
    //if (!controller.value.isInitialized) {
    //return
    const SizedBox(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
    // }
    return Scaffold(
      body: ChangeNotifierProvider(create: (_) => PoseDetectionState(), child: const PoseDetectionPage()),
    );
  }
}
