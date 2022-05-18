import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pushups_counter2/screens/camera_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: const Center(
        child: Text(
          'Home Screen',
          style: TextStyle(color: Colors.black),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await availableCameras().then(
            (value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CameraScreen(
                  cameras: value,
                ),
              ),
            ),
          );
        },
        child: const Text('Start'),
      ),
    );
  }
}
