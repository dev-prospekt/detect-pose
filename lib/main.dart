import 'package:flutter/material.dart';
import 'MyHomePage.dart';
import 'StartPage.dart';

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
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          primarySwatch: Colors.grey,
        ),
        home: const MyHomePage(title: 'PUSHUPS COUNTER'),
        routes: <String, WidgetBuilder>{
          '/StartPage': (context) => StartPage()
        });
  }
}
