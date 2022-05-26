import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'PoseDetectionPage.dart';

class StartDashboard extends StatefulWidget {
  final List<CameraDescription>? cameras;

  const StartDashboard({this.cameras, Key? key}) : super(key: key);

  @override
  _StartDashboardState createState() => _StartDashboardState();
}

class _StartDashboardState extends State<StartDashboard> {
  late CameraController controller;

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
