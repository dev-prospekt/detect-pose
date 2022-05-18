import 'package:flutter/material.dart';
import 'package:pushups_counter2/screens/home_screen.dart';

void main() {
  //Get list of available cameras
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PUSHUPS COUNTER',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomeScreen(),
    );
  }
}
