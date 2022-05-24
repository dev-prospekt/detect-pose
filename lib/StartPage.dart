import 'dart:ffi';
import 'dart:js';

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
      body: Column(
        children: [
          Expanded(
            child: ChangeNotifierProvider(
                create: (_) => PoseDetectionState(),
                child: const PoseDetectionPage()),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                child: Text(
                  "Number of pushups: $_counter",
                  style: const TextStyle(color: Colors.grey, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
