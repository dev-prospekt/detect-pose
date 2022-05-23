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

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras![1],
      ResolutionPreset.medium,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ChangeNotifierProvider(
              create: (_) => PoseDetectionState(),
              child: PoseDetectionPage(),
            ),
          ),
          Row(children: [
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 10, 5),
              child: const Text(
                'Number of pushups: 0',
                style: TextStyle(color: Colors.grey, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 10, 5),
              child: FlatButton(
                child: Text(
                  'START',
                  style: TextStyle(fontSize: 17.0),
                ),
                color: Colors.purple.shade200,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                onPressed: () {},
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
